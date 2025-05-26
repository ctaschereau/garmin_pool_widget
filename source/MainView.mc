using Toybox.Communications;
using Toybox.WatchUi as Ui;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.PersistedContent;
using Toybox.Timer;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application.Storage;

// Global variable in order to be able to access it in the GraphView
var lastDayData as Array<Dictionary>?;

class MainView extends Ui.View {
    var lastResponseCode as Number?;
    var mostRecentPoolReadMoment as Time.Moment?;
    var mostRecentPoolReadTemp as Number?;

    var timerCount = 0;
    // var myTimer as Timer.Timer?;

    function initialize() {
        Ui.View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainView(dc));
    }

    function onShow() {
        // Check if watch has internet access first
        if (!System.getDeviceSettings().connectionAvailable) {
            return;
        }

        callServerForTemperature();

        manageTimer();
    }

    function callServerForTemperature() as Void {
        lastDayData = null;
        timerCount++;

        var url = "https://pool.capy.motorcycles/data/pool";
        var params = {
            "rangeToDisplay" => "24hours"
        };

        var options = { 
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

    function manageTimer() as Void {
        if (myTimer == null) {
            myTimer = new Timer.Timer();
            myTimer.start(method(:callServerForTemperature), 1800000, true); // 1800000 milliseconds = 30 minutes
        } else if (timerCount == 6) {
            myTimer.stop();
            myTimer = null;
        }
    }

    function onUpdate(dc) {
        var responseText;
        var labelError = View.findDrawableById("labelError") as Ui.Text;
        var labelTemperature = View.findDrawableById("labelTemperature") as Ui.Text;
        if (!System.getDeviceSettings().connectionAvailable) {
            responseText = Rez.Strings.NoInternet as String;
            labelTemperature.setVisible(true);
            labelError.setVisible(false);
        } else if (lastResponseCode == null) {
            responseText = Rez.Strings.Loading as String;
            labelTemperature.setText(responseText);
            labelTemperature.setVisible(true);
            labelError.setVisible(false);
        } else if (lastResponseCode == 200) {
            var mostRecentTempReadDateString = getPoolReadDateString();
            var tempAsString = mostRecentPoolReadTemp.format("%2.1f") + "°C";
            setGlanceViewTempString(tempAsString, mostRecentTempReadDateString);
            labelTemperature.setText(tempAsString);
            var date = View.findDrawableById("date") as Ui.Text;
            date.setText("@" + mostRecentTempReadDateString);
            labelTemperature.setVisible(true);
            labelError.setVisible(false);
        } else {
            responseText = WatchUi.loadResource(Rez.Strings.Error)  + " : " + lastResponseCode;
            labelError.setText(responseText);
            labelTemperature.setVisible(false);
            labelError.setVisible(true);
        }
        
        View.onUpdate(dc);
    }

    function setGlanceViewTempString(tempAsString as String, mostRecentTempReadDateString as String) as Void {
        var lastGoodReadText = tempAsString + " @ " + mostRecentTempReadDateString;
        Storage.setValue("lastGoodReadText", lastGoodReadText);
    }

    function getPoolReadDateString() as String {
        var myGregorianInfo = Gregorian.info(mostRecentPoolReadMoment, Time.FORMAT_MEDIUM);
        return Lang.format(
            "$1$:$2$",
            [
                myGregorianInfo.hour,
                myGregorianInfo.min.format("%02d")
            ]
        );
    }

    function onReceive(responseCode as Number, data as Null or Dictionary or String or PersistedContent.Iterator) as Void {
        lastResponseCode = responseCode;
        if (responseCode == 200 && data instanceof Array) {
            lastDayData = data as Array<Dictionary>;
            // data is an array, so grab the first element's "temp" property
            var latestData = (data as Array<Dictionary>)[data.size() - 1];
            mostRecentPoolReadTemp = latestData["temp"] as Number;
            mostRecentPoolReadMoment = new Time.Moment((latestData["dateInMs"] as Number) / 1000);
        }
        WatchUi.requestUpdate();
    }
}