using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;

const CHART_WIDTH = 96;
const CHART_HEIGHT = 50;

class GraphView extends Ui.View {
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Gfx.Dc) as Void {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawRectangle(42, 80, CHART_WIDTH, CHART_HEIGHT);

        // lastDayData is an array of dictionaries. Each of them conatains both a "dateInMs" and a "temp" key.
        // Using this, plot a chart of the temperature over the last 24 hours in the above rectangle.

        // Process and plot the data
        if (lastDayData.size() > 0) {
            var minTemp = 100000; // Initialize with a very high number
            var maxTemp = -100000; // Initialize with a very low number
            var now = Time.now().value();
            var twentyFourHoursAgo = now - 24 * 60 * 60;

            // Find min and max temperatures
            for (var i = 0; i < lastDayData.size(); i++) {
                var temp = lastDayData[i]["temp"] as Number;
                if (temp < minTemp) { minTemp = temp; }
                if (temp > maxTemp) { maxTemp = temp; }
            }
            minTemp = Math.floor(minTemp) - 1;
            maxTemp = Math.ceil(maxTemp) + 1;

            // Plot the data points
            var prevX = 0;
            var prevY = 0;
            for (var i = 0; i < lastDayData.size(); i++) {
                var dateInSeconds = (lastDayData[i]["dateInMs"] as Number) / 1000;
                var temp = lastDayData[i]["temp"] as Number;

                if (dateInSeconds >= twentyFourHoursAgo && dateInSeconds <= now) {
                    var x = 42 + (dateInSeconds - twentyFourHoursAgo) * CHART_WIDTH / (24 * 60 * 60);
                    var y = 80 + CHART_HEIGHT - (temp - minTemp) * CHART_HEIGHT / (maxTemp - minTemp);

                    if (prevX != 0 && prevY != 0) {
                        dc.drawLine(prevX, prevY, x, y);
                    }

                    prevX = x;
                    prevY = y;
                }
            }

            // Draw axes labels
            dc.drawText(37, 68, Graphics.FONT_XTINY, maxTemp.format("%2.1f"), Graphics.TEXT_JUSTIFY_RIGHT);
            dc.drawText(37, 68 + CHART_HEIGHT, Graphics.FONT_XTINY, minTemp.format("%2.1f"), Graphics.TEXT_JUSTIFY_RIGHT);
            // Draw line over the 23 deg temperature
            var yPos = 80 + CHART_HEIGHT - (23 - minTemp) * CHART_HEIGHT / (maxTemp - minTemp);
            dc.drawLine(42 + 5, yPos, 42 + CHART_WIDTH - 5, yPos);
        } else {
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_SMALL, "No data available", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}