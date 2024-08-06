import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class App extends Application.AppBase {

    private var _mainView as MainView?;
    private var _secondView as GraphView?;
    private var _views as Array<WatchUi.View>?;

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        _mainView = new MainView();
        _secondView = new GraphView();
        _views = [_mainView, _secondView];
        return [_views[0], new WidgetDelegate(_views)];
    }

    (:glance)
    function getGlanceView() as [ WatchUi.GlanceView ] or [ WatchUi.GlanceView, WatchUi.GlanceViewDelegate ] or Null {
        return [ new GlanceView() ];
    }
}

function getApp() as App {
    return Application.getApp() as App;
}