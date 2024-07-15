using Toybox.WatchUi as Ui;

class MainView extends Ui.View {
    var temp, timestamp;

    function initialize(temp, timestamp) {
        System.println("ced MainView 1");
        Ui.View.initialize();
        self.temp = temp;
        self.timestamp = timestamp;
        System.println("ced MainView 2");
    }

    function onUpdate(dc) {
        System.println("ced MainView onUpdate");
        dc.clear();
        
        dc.drawText(5, 5, Graphics.FONT_LARGE, "Pool Temp: " + temp + "°C", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(5, 25, Graphics.FONT_LARGE, "Last Updated: " + timestamp, Graphics.TEXT_JUSTIFY_CENTER);
    }
}