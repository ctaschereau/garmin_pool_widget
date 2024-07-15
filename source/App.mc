import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class App extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
        //var glanceView = new GlanceView();
        //Ui.pushView(glanceView, null, Ui.SLIDE_UP);
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new GlanceView() ];
    }
}

function getApp() as App {
    return Application.getApp() as App;
}