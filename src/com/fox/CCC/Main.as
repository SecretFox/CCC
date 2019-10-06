/**
import com.Utils.archieve:
 * ...
 * @author fox
 */
import com.Utils.Archive;
import com.fox.CCC.Mod
 
class com.fox.CCC.Main 
{
	private static var s_app:Mod;

	public static function main(swfRoot:MovieClip):Void
	{
		s_app = new Mod(swfRoot);
		swfRoot.onLoad = OnLoad;
		swfRoot.onUnload = OnUnload;
		swfRoot.OnModuleActivated = OnActivated;
		swfRoot.OnModuleActivated = OnActivated;
		swfRoot.OnModuleDeactivated = OnDeactivated;
	}

	public function Main() { }
	public static function OnLoad():Void
	{
		s_app.Load();
	}
		public static function OnUnload():Void
	{
		s_app.Unload();
	}
	
	public static function OnActivated(config: Archive):Void
	{
		s_app.Activate(config);
	}

	public static function OnDeactivated():Archive
	{
		return s_app.Deactivate();
	}
}