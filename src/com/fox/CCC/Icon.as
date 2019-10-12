import com.GameInterface.DistributedValueBase;
import com.fox.Utils.Common;
import flash.geom.Point;
import mx.utils.Delegate;
import com.Utils.GlobalSignal;
import com.GameInterface.Tooltip.TooltipInterface;
import com.GameInterface.Tooltip.TooltipData;
import com.GameInterface.Tooltip.TooltipManager;

class com.fox.CCC.Icon {
	private var m_swfRoot:MovieClip;
	private var m_Icon:MovieClip;
	private var m_pos:Point;
	private var Tooltip:TooltipInterface;
	

	public function Icon(swfRoot: MovieClip) {
		m_swfRoot = swfRoot;
	}
	
	public function Activate(pos:Point){
		m_pos = pos;
		if (!m_Icon) CreateTopIcon();
	}
	public function Unload(){
		m_Icon.removeMovieClip();
	}
	public function getPos(){
		return m_pos;
	}
	//Ghetto Guiedit
	private function GuiEdit(state:Boolean) {
		if (state) {
			m_Icon.onPress = Delegate.create(this,function ():Void {
				this.m_Icon.startDrag();
			});
			m_Icon.onRelease = Delegate.create(this,function ():Void {
				this.m_Icon.stopDrag();
			});
			m_Icon.onReleaseOutside = Delegate.create(this,function ():Void {
				this.m_Icon.stopDrag();
			});
			m_Icon.onRollOver = undefined;
			m_Icon.onRollOut = undefined;
			Tooltip.Close();
		} else {
			m_Icon.onRelease = undefined;
			m_Icon.onReleaseOutside = undefined;
			m_Icon.onRollOver = Delegate.create(this, function() {
				this.Tooltip.Close();
				var m_TooltipData:TooltipData = new TooltipData();
				m_TooltipData.m_Title = "<font size='14'>CustomCharacterCreator v.0.4.0</font>";
				m_TooltipData.m_Color = 0xE37904;
				m_TooltipData.AddDescription("<font size='12'>Left click to open settings\n\nMoveable while in GUIEdit mode</font>");
				m_TooltipData.m_MaxWidth = 300;
				this.Tooltip = TooltipManager.GetInstance().ShowTooltip(undefined, TooltipInterface.e_OrientationVertical,0.5, m_TooltipData);
			});
			m_Icon.onRollOut = Delegate.create(this, function() {
				this.Tooltip.Close();
			});
			m_Icon.stopDrag();
			m_Icon.onPress = Delegate.create(this, Toggle);
			m_Icon.onRelease = undefined;
			m_Icon.onReleaseOutside = undefined;
			m_pos = Common.getOnScreen(m_Icon);
			m_Icon._x = m_pos.x;
			m_Icon._y = m_pos.y;
		}
	}
	private function Toggle(){
		DistributedValueBase.SetDValue("CCC_Settings", !DistributedValueBase.GetDValue("CCC_Settings"));
		
	}
	private function CreateTopIcon():Void {
		m_Icon = m_swfRoot.attachMovie("src.assets.Icon.3_37.png", "m_Icon", m_swfRoot.getNextHighestDepth(), {_x:m_pos.x, _y:m_pos.y, _width:20, _height:20});
		GlobalSignal.SignalSetGUIEditMode.Connect(GuiEdit, this);
		GuiEdit(false);
	}
}