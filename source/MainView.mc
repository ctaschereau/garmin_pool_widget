using Toybox.Communications;
using Toybox.WatchUi as Ui;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.PersistedContent;

var responseText;

class MainView extends Ui.View {

    function initialize() {
        Ui.View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        responseText = Rez.Strings.Loading;
        setLayout(Rez.Layouts.MainView(dc));
    }

    // https://developer.garmin.com/connect-iq/user-experience-guidelines/instinct-2022/
    function onShow() {
        // Check if watch has internet access first
        if (!System.getDeviceSettings().connectionAvailable) {
            responseText = Rez.Strings.NoInternet;
            return;
        }

        var url = "https://pool.ctasc.site/data/pool";
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

    function onUpdate(dc) {
        var labelTemperature = View.findDrawableById("labelTemperature") as Ui.Text;
        labelTemperature.setText(responseText);
        View.onUpdate(dc);
    }

    function onReceive(responseCode as Number, data as Null or Dictionary or String or PersistedContent.Iterator) as Void {
        if (responseCode == 200 && data instanceof Array) {
            // data is an array, so grab the first element's "temp" property
            var latestData = (data as Array<Dictionary>)[data.size() - 1];
            var tempAsNumber = latestData["temp"] as Number;
            var tempAsString = tempAsNumber.format("%2.1f");
            // System.println("Temp now : " + tempAsString);
            responseText = tempAsString + "°C";
        } else {
            responseText = Rez.Strings.Error + " : " + responseCode;
        }
        WatchUi.requestUpdate();
    }
}