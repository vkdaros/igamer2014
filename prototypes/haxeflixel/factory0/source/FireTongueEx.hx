import firetongue.FireTongue;
import flixel.addons.ui.interfaces.IFireTongue;

/**
 * This is a simple wrapper class in the actual project
 * code that includes both libraries FireTongue and Flixel-UI.
 *
 * The wrapper extends FireTongue, and implements IFireTongue
 *
 * The actual extended class does nothing, it just falls through to FireTongue.
 *
 * Code from flx-demos/User Interface/RPG Interface.
 */
class FireTongueEx extends FireTongue implements IFireTongue {
    public function new() {
        super();
    }
}
