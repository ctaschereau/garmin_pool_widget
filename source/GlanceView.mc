using Toybox.Communications;
using Toybox.WatchUi as Ui;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.PersistedContent;

var responseText = "Loading...";

class GlanceView extends Ui.View {

    function initialize() {
        Ui.View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainView(dc));
    }

    function onShow() {
        var url = "https://pool.ctasc.site/data/pool";                         // set the url

        var params = {                                              // set the parameters
            "rangeToDisplay" => "24hours"
        };

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
            // set response type
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
            // log("Response: " + responseCode);            // print response code
            // log("Response data: " + data);            // print response code

            // onError();
        }
        WatchUi.requestUpdate();
    }

    function onError() {
        Ui.popView(Ui.SLIDE_UP);
        var mainView = new MainView("Error", "Error");
        Ui.pushView(mainView, null, Ui.SLIDE_UP);
    }
}