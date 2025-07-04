using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;

(:glance)
class GlanceView extends Ui.GlanceView {

    function initialize() {
        Ui.GlanceView.initialize();
    }

    function onShow() {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var label = Application.loadResource( Rez.Strings.AppName );

        var lastGoodReadText = Storage.getValue("lastGoodReadText");
        var lastGoodReadTimestamp = Storage.getValue("lastGoodReadTimestamp");
        
        if (lastGoodReadText != null && lastGoodReadTimestamp != null) {
            // Check if the reading is from today
            var readingMoment = new Time.Moment(lastGoodReadTimestamp as Number);
            var now = Time.now();
            
            var readingDate = Gregorian.info(readingMoment, Time.FORMAT_SHORT);
            var currentDate = Gregorian.info(now, Time.FORMAT_SHORT);
            
            // Only show if reading is from the same day
            if (readingDate.year == currentDate.year && 
                readingDate.month == currentDate.month && 
                readingDate.day == currentDate.day) {
                label += '\n' + lastGoodReadText;
            }
        }
        dc.drawText(0, dc.getHeight() / 2, Gfx.FONT_GLANCE, label, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
}