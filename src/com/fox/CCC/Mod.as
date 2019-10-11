/**
 * ...
 * @author fox
 */
import GUI.fox.aswing.JFrame;
import com.GameInterface.UtilsBase;
import com.fox.CCC.BodyParts;
import com.fox.CCC.Icon;
import com.GameInterface.DistributedValue;
import com.GameInterface.DressingRoom;
import com.GameInterface.Game.Character;
import com.Utils.Archive;
import com.fox.CCC.Settings;
import flash.geom.Point;
import GUI.fox.aswing.TswLookAndFeel;
import GUI.fox.aswing.ASWingUtils;
import GUI.fox.aswing.UIManager;
import mx.utils.Delegate;

class com.fox.CCC.Mod {
	public var d_Settings:DistributedValue;
	public var d_Enabled:DistributedValue;
	private var d_Export:DistributedValue;
	private var d_Import:DistributedValue;
	public var s_SerializedLook:String;
	public var s_SerializedConfig:String;
	private var s_Minimized:Boolean;
	public var s_DisableIdle:Boolean;
	
	private var m_swfroot:MovieClip;
	private var m_Icon:Icon;
	private var m_settingsRoot:MovieClip;
	private var m_Settings:Settings;
	private var m_Settings_Pos:Point;
	private var m_Icon_Pos:Point;
	
	public var m_Char:Character;
	public var m_bodyparts:BodyParts;
	
	public function Mod(root){
		m_swfroot = root;
	}
	public function Load(){
		m_settingsRoot.removeMovieClip();	
		m_settingsRoot = m_swfroot.createEmptyMovieClip("m_settingsRoot", m_swfroot.getNextHighestDepth());
		ASWingUtils.setRootMovieClip(m_settingsRoot);
		var laf:TswLookAndFeel = new TswLookAndFeel();
		UIManager.setLookAndFeel(laf);
		
		d_Settings = DistributedValue.Create("CCC_Settings");
		d_Enabled = DistributedValue.Create("CCC_Enabled");
		d_Import = DistributedValue.Create("CCC_Import");
		d_Export = DistributedValue.Create("CCC_Export");
		m_Icon = new Icon(m_swfroot);
		m_bodyparts = new BodyParts();
		d_Settings.SignalChanged.Connect(DrawSettings, this);
		d_Enabled.SignalChanged.Connect(ApplyLooks, this);
		d_Import.SignalChanged.Connect(Import, this);
		d_Export.SignalChanged.Connect(Export, this);
	}
	public function Unload(){
		d_Settings.SignalChanged.Disconnect(DrawSettings, this);
		d_Enabled.SignalChanged.Disconnect(ApplyLooks, this);
		d_Import.SignalChanged.Disconnect(Import, this);
		d_Export.SignalChanged.Disconnect(Export, this);
		m_Icon.Unload();
	}
	private function DrawSettings(){
		if (d_Settings.GetValue()){
			if(!m_Settings)	m_Settings = new Settings(this, m_Settings_Pos, s_SerializedConfig, s_Minimized);
		}else{
			if (m_Settings){
				m_Settings_Pos = m_Settings.getPos();
				s_Minimized = m_Settings.getMinimized();
				m_Settings.dispose();
				m_Settings = undefined;
			}
		}
	}
	public function Activate(config:Archive){
		m_Settings_Pos = config.FindEntry("SettingPos", new Point(100, 100));
		m_Icon_Pos = config.FindEntry("IconPos", new Point(100, 20));
		d_Settings.SetValue(config.FindEntry("Settings"));
		d_Enabled.SetValue(config.FindEntry("Enable"));
		s_SerializedConfig = config.FindEntry("Config");
		s_SerializedLook = config.FindEntry("Look");
		s_Minimized = config.FindEntry("Minimized", false);
		s_DisableIdle = config.FindEntry("DisableIdle", true);
		
		m_Char = Character.GetClientCharacter();
		m_Icon.Activate(m_Icon_Pos);
		DrawSettings();
		setTimeout(Delegate.create(this, ApplyLooks), 1000);
	}
	
	public function Deactivate():Archive{
		var config:Archive = new Archive();
		config.AddEntry("SettingPos", m_Settings.getPos() || m_Settings_Pos);
		config.AddEntry("IconPos", m_Icon.getPos());
		config.AddEntry("Settings", d_Settings.GetValue());
		config.AddEntry("Enable", d_Enabled.GetValue());
		config.AddEntry("Config", s_SerializedConfig);
		config.AddEntry("Minimized", m_Settings.getMinimized() || false);
		config.AddEntry("DisableIdle", s_DisableIdle);
		config.AddEntry("Look", s_SerializedLook);
		return config
	}
	
	public function ApplyLooks(override:Array){
		if (d_Enabled.GetValue()){
			if (s_SerializedLook || override){
				m_Char.RemoveAllLooksPackages();
				if (s_DisableIdle && 
					m_Settings && 
					m_Settings.getState() == JFrame.NORMAL
				){
					m_Char.SetBaseAnim("normal_idle");
				}
				var Assassin = m_Char.GetStat(56) == 2 ? 33565 : 33565;
				var pairs:Array = override || s_SerializedLook.split(";");
				if (pairs[0] != "norestore"){
					DressingRoom.PreviewNodeItem(Assassin);
					DressingRoom.ClearPreview();
				}else{
					pairs.shift();
				}
				for (var i in pairs){
					var value = pairs[i].split(",");
					m_Char.AddLooksPackage(Number(value[0]), Number(value[1]));
				}
			}
		}else{
			/*
			 * https://github.com/super-jenius/Untold/blob/master/LooksTier.as this just crashes for me, need to investigate
			 * m_Char.RemoveAllLooksPackages();
			 * var characterCreationIF:CharacterCreation = new com.GameInterface.CharacterCreation.CharacterCreation(true);
			 * var eyeColor = characterCreationIF.GetEyeColorIndex();
			 * characterCreationIF.SetEyeColorIndex(1);
			 * characterCreationIF.SetEyeColorIndex(0);
			 * characterCreationIF.SetEyeColorIndex(eyeColor);
			*/
		}
	}
	
	private function Import(dv:DistributedValue){
		var str:String = dv.GetValue()
		if (str){
			if (str.indexOf("nosave") == -1){
				
				s_SerializedLook = str;
				ApplyLooks();
			}else{
				var arr:Array = str.split(";");
				arr.shift();
				ApplyLooks(arr);
			}
			dv.SetValue(false);
		}
	}
	
	private function Export(dv:DistributedValue){
		if (dv.GetValue()){
			UtilsBase.PrintChatText("\"" + s_SerializedLook + "\"");
			dv.SetValue(false);
		}
	}
}