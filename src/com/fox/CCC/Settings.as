import GUI.fox.aswing.ASColor;
import GUI.fox.aswing.ASTextFormat;
import GUI.fox.aswing.GridLayout;
import GUI.fox.aswing.Icon;
import GUI.fox.aswing.JButton;
import GUI.fox.aswing.JCheckBox;
import GUI.fox.aswing.JFrame;
import GUI.fox.aswing.JPanel;
import GUI.fox.aswing.JSlider;
import GUI.fox.aswing.JTextField;
import GUI.fox.aswing.SoftBoxLayout;
import GUI.fox.aswing.border.BevelBorder;
import com.GameInterface.DistributedValueBase;
import com.GameInterface.Game.Character;
import com.GameInterface.UtilsBase;
import com.fox.CCC.BodyParts;
import com.fox.CCC.Mod;
import flash.geom.Point;
import mx.utils.Delegate;

	
class com.fox.CCC.Settings extends JFrame {
	private var m_Mod:Mod;
	private var m_Bodypart:BodyParts;
	private var m_Char:Character;
	private var sex:String;
	private var tempSliders:String;
	
	private var winPos:Point
	
	private var DisableIdle:JCheckBox;
	private var EnableCheckbox:JCheckBox;
	private var SaveButton:JButton;
	private var ExportButton:JButton;
	private var ImportButton:JButton;
	private var SliderPanel:JPanel;
	private var inputField:JTextField
	
	private var sliders:Array = new Array();
	private var Tfs:Array = new Array();

	public function Settings(that:Mod,pos:Point,config, minimized) {
		super("CCC");
		m_Mod = that;
		m_Bodypart = m_Mod.m_bodyparts;
		m_Char = m_Mod.m_Char;
		sex = m_Char.GetStat(59) == 2 ? "Male":"Female";
	//window config
		winPos = pos;
		setLocation(pos.x, pos.y);
		setBorder(new BevelBorder(undefined, BevelBorder.RAISED, new ASColor(0xD8D8D8), new ASColor(0x7C7C7C), new ASColor(0x000000), new ASColor(0x373737), 3));
		var icon:Icon = new Icon();//Empty icon
		setIcon(icon);
		setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
	//content
		var content:JPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
		content.append(GetSliders());
		inputField = new JTextField();
		inputField.setEditable(true);
		inputField.setEnabled(true);
		inputField.setBorder(null);
		inputField.setRestrict("0-9;");
		var format:ASTextFormat = inputField.getTextFormat();
		format.setAlign(ASTextFormat.CENTER);
		inputField.setTextFormat(format);
		content.append(inputField);
		
		content.append(GetButtons());
		content.append(GetCheckboxes());
	//show window
		setContentPane(content)
		show();
		pack();
		bringToTopDepth();
		ApplyConfigs(config);
		//setInterval(Delegate.create(this,getMinimized),1000)
		if (minimized) setState(JFrame.ICONIFIED);
	}
	// Replaces the default tryToClose function
	// Mod.as will grab window position and then calls for dispose()
	public function tryToClose():Void{
		DistributedValueBase.SetDValue("CCC_Settings", !DistributedValueBase.GetDValue("CCC_Settings"));	
	}
	// Mod.as will close the window after getting the window position
	private function __CloseWindow(){
		DistributedValueBase.SetDValue("CCC_Settings", !DistributedValueBase.GetDValue("CCC_Settings"));
	}
	public function getMinimized(){
		return getState() == JFrame.ICONIFIED ? true:false;
	}
	public function getPos(){
		return new Point(getX(), getY());
	}
	private function GetLength(object){
		var i:Number = 0;
		for (var y in object) i++
		return i-1
	}
	private function GetSubLength(object){
		var i:Number = 0;
		for (var y in object){
			for (var x in object[y]){
				i++
			}
			return i
		}
		return i
	}
	private function GetKeyByIndex(object, idx){
		var i:Number = 0;
		for (var y in object){
			if (idx == i){
				return y
			}
			i++
		}
	}
	private function OrderedObject(o, num){
		var ret:Array = new Array();
		for (var i in o){
			ret.push(Number(i));
		}
		ret.push(0);

		ret.sort(Array.NUMERIC);
		return ret[num];
	}
	private function OrderedArray(a:Array, num){
		return a.sort(Array.NUMERIC)[num];
	}
//Content
	private function GetSliders():JPanel{
		if (SliderPanel == undefined){
			SliderPanel = new JPanel();
			var SliderPane:JPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
			var TextPane:JPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 8));
			
			sliders = [
				new JSlider(JSlider.HORIZONTAL, 0, GetLength(m_Bodypart.Head[sex])+1, 0), // Head
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(m_Bodypart.Head[sex]), 0), // Face
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(m_Bodypart.Hair[sex])-1, 0), // Hair
				new JSlider(JSlider.HORIZONTAL, 0, GetLength(m_Bodypart.Hair_Color)+1, 0), // Color type
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(m_Bodypart.Hair_Color), 0), // Color
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(m_Bodypart.Facial_Details[sex])-1, 0), // Facial Detail
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(m_Bodypart.Facial_Hair[sex])-1, 0), // Facial Hair
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(m_Bodypart.Facial_Hair_Color[sex])-1, 0), // Facial Hair Color
				new JSlider(JSlider.HORIZONTAL, 0, GetLength(m_Bodypart.Makeup[sex])+1, 0), // Makeup
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(m_Bodypart.Makeup[sex]), 0) // Var
			];
			sliders[0].addChangeListener(__HeadChanged, this);
			sliders[1].addChangeListener(__FaceChanged, this);
			sliders[2].addChangeListener(__HairChanged, this);
			sliders[3].addChangeListener(__HairColorTypeChanged, this);
			sliders[4].addChangeListener(__HairColorChanged, this);
			sliders[5].addChangeListener(__FacialDetailChanged, this);
			sliders[6].addChangeListener(__FacialHairChanged, this);
			sliders[7].addChangeListener(__FacialHairColorChanged, this);
			sliders[8].addChangeListener(__MakeupChanged, this);
			sliders[9].addChangeListener(__MakeupVarChanged, this);
			for (var i:Number = 0; i < sliders.length;i++){
				sliders[i].setSnapToTicks(true);
				sliders[i].setMinorTickSpacing(1);
				sliders[i].setFocusable(false);
				SliderPane.append(sliders[i]);
			}
			
			Tfs = [
				new JTextField("Head 0", 20),
				new JTextField("Face 0", 20),
				new JTextField("Hair 0", 20),
				new JTextField("Color Type 0", 20),
				new JTextField("Color 0", 20),
				new JTextField("Detail 0", 20),
				new JTextField("Facial Hair 0", 20),
				new JTextField("Color 0", 20),
				new JTextField("Makeup 0", 20),
				new JTextField("Var 0", 20)
			];
			for (var i:Number = 0; i < Tfs.length;i++){
				Tfs[i].setEditable(false);
				Tfs[i].setFocusable(false);
				Tfs[i].setBorder(null);
				Tfs[i].setEnabled(false);
				TextPane.append(Tfs[i]);
			}
			
			SliderPanel.append(SliderPane);
			SliderPanel.append(TextPane);
		}
		return SliderPanel
	}
	private function GetCheckboxes():JPanel {
		var CheckboxPane:JPanel = new JPanel();
		CheckboxPane.append(GetEnableCheckbox());
		CheckboxPane.append(GetDisableIdleCheckbox());
		return CheckboxPane
	}
//Apply Look
	private function SerializeLooks(){
		
		var serialized:Array = [];
		
		var part = m_Bodypart.Head[sex]
		var package_idx = Math.round(sliders[0].getValue());
		var look_Idx = Math.round(sliders[1].getValue());
		var key
		if (package_idx != 0){
			key = OrderedObject(part, package_idx);
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		
		part = m_Bodypart.Hair[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[2].getValue());
		if (look_Idx != 0){
			key = GetKeyByIndex(part, 0);
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		part = m_Bodypart.Hair_Color;
		package_idx = Math.round(sliders[3].getValue());
		look_Idx = Math.round(sliders[4].getValue());
		if (package_idx != 0){
			key = GetKeyByIndex(part, package_idx-1);
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		
		part = m_Bodypart.Facial_Details[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[5].getValue());
		key = GetKeyByIndex(part, package_idx);
		if (part[key][look_Idx] != 0){
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		part = m_Bodypart.Facial_Hair[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[6].getValue());
		key = GetKeyByIndex(part, package_idx);
		if (part[key][look_Idx] != 0){
			serialized.push([Number(key), part[key][look_Idx]].join(","));
			
		}
		
		part = m_Bodypart.Facial_Hair_Color[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[7].getValue());
		key = GetKeyByIndex(part, package_idx);
		if (part[key][look_Idx] != 0){
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		part = m_Bodypart.Makeup[sex];
		package_idx = Math.round(sliders[8].getValue());
		look_Idx = Math.round(sliders[9].getValue());
		
		if (package_idx != 0){
			key = OrderedObject(part, package_idx);
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		m_Mod.s_SerializedLook = serialized.join(";");
		if(m_Mod.d_Enabled.GetValue() )m_Mod.ApplyLooks();
	}
	private function Serialize(){
		var config:Array = new Array();
		for (var i:Number=0; i < sliders.length; i++){
			config.push(sliders[i].getValue());
		}
		return config
	}
	public function ApplyConfigs(configpack){
		var values = configpack.split(";");
		sliders[0].setValue(values[0]);
		sliders[1].setValue(values[1]);
		sliders[2].setValue(values[2]);
		sliders[3].setValue(values[3]);
		sliders[4].setValue(values[4]);
		sliders[5].setValue(values[5]);
		sliders[6].setValue(values[6]);
		sliders[7].setValue(values[7]);
		sliders[8].setValue(values[8]);
		sliders[9].setValue(values[9]);
	}
//Slider actions
	private function __HeadChanged(slider:JSlider){
		var val =  Math.round(slider.getValue());
		Tfs[0].setText("Head " + val);
		var key = OrderedObject(m_Bodypart.Head[sex], val);
		sliders[1].setMaximum(m_Bodypart.Head[sex][key].length - 1);
		if (sliders[1].getMaximum() == 0){
			sliders[1].setEnabled(false);
		}else{
			sliders[1].setEnabled(true);
		}
		if (sliders[1].getValue() == 0){
			__FaceChanged(sliders[1]);
			return
		}
		sliders[1].setValue(0);
	}
	private function __FaceChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[1].setText("Face " + val);
		SerializeLooks();
	}
	private function __HairChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[2].setText("Hair " + val);
		SerializeLooks();
	}
	private function __HairColorTypeChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[3].setText("Color Type " + val);
		var key = OrderedObject(m_Bodypart.Hair_Color, val);
		sliders[4].setMaximum(m_Bodypart.Hair_Color[key].length - 1);
		if (sliders[4].getValue() == 0){
			__HairColorChanged(sliders[4]);
			return
		}
		sliders[4].setValue(0);
	}
	private function __HairColorChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[4].setText("Color " + val);
		SerializeLooks();
	}
	private function __FacialDetailChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[5].setText("Detail " + val);
		SerializeLooks();
	}
	private function __FacialHairChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[6].setText("Facial Hair " + val);
		SerializeLooks();
	}
	private function __FacialHairColorChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[7].setText("Color " + val);
		SerializeLooks();
	}
	private function __MakeupChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[8].setText("Makeup " + val);
		var key = OrderedObject(m_Bodypart.Makeup[sex], val);
		sliders[9].setMaximum(m_Bodypart.Makeup[sex][key].length - 1);
		if (sliders[9].getMaximum() == 0){
			sliders[9].setEnabled(false);
		}else{
			sliders[9].setEnabled(true);
		}
		if (sliders[9].getValue() == 0){
			__MakeupVarChanged(sliders[9]);
			return
		}
		sliders[9].setValue(0);
	}
	private function __MakeupVarChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[9].setText("Var " + val);
		SerializeLooks();
	}
	private function __Save(){
		var config:Array = Serialize();
		m_Mod.s_SerializedConfig = config.join(";");
	}
	private function __Export(){
		var config:Array = Serialize();
		inputField.setText(config.join(";"));
	}
	private function __Import(){
		var txt = inputField.getText();
		m_Mod.s_SerializedConfig = txt;
		ApplyConfigs(txt);
		m_Mod.ApplyLooks();
	}
//Buttons
	private function GetButtons(){
		var buttonPane:JPanel = new JPanel(new GridLayout(1, 3, 5, 5));
		buttonPane.append(GetSaveButton());
		buttonPane.append(GetExportButton());
		buttonPane.append(GetImportButton());
		return buttonPane
	}
	private function GetSaveButton(){
		if (SaveButton == null){
			SaveButton = new JButton("Save");
			SaveButton.addActionListener(__Save, this);
		}
		return SaveButton
	}
	private function GetExportButton(){
		if (ExportButton == null){
			ExportButton = new JButton("Export");
			ExportButton.addActionListener(__Export, this);
		}
		return ExportButton
	}
	private function GetImportButton(){
		if (ImportButton == null){
			ImportButton = new JButton("Import");
			ImportButton.addActionListener(__Import, this);
		}
		return ImportButton
	}
//Checkboxes
	private function __EnableChanged(checkbox:JCheckBox){
		m_Mod.d_Enabled.SetValue(checkbox.isSelected());
	}
	private function __DisableChanged(checkbox:JCheckBox){
		m_Mod.s_DisableIdle = checkbox.isSelected();
	}
	private function GetEnableCheckbox(){
		if (EnableCheckbox == null){
			EnableCheckbox = new JCheckBox("Enabled");
			EnableCheckbox.setSelected(m_Mod.d_Enabled.GetValue());
			EnableCheckbox.addActionListener(__EnableChanged, this);
		}
		return EnableCheckbox;
	}
	private function GetDisableIdleCheckbox(){
		if (DisableIdle == null){
			DisableIdle = new JCheckBox("Disable idle animations");
			DisableIdle.setSelected(m_Mod.s_DisableIdle);
			DisableIdle.addActionListener(__DisableChanged, this);
		}
		return DisableIdle;
	}
	
}