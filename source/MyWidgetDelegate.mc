import Toybox.WatchUi;
import Toybox.Lang;

class MyWidgetDelegate extends WatchUi.BehaviorDelegate {
    private var _views as Array<WatchUi.View>;
    private var _currentViewIndex as Number;

    function initialize(views as Array<WatchUi.View>) {
        BehaviorDelegate.initialize();
        _views = views;
        _currentViewIndex = 0;
    }

    function onNextPage() as Boolean {
        if (_currentViewIndex < _views.size() - 1) {
            _currentViewIndex++;
            WatchUi.switchToView(_views[_currentViewIndex], null, WatchUi.SLIDE_UP);
        }
        return true;
    }

    function onPreviousPage() as Boolean {
        if (_currentViewIndex > 0) {
            _currentViewIndex--;
            WatchUi.switchToView(_views[_currentViewIndex], null, WatchUi.SLIDE_DOWN);
        }
        return true;
    }
}