import GUI.fox.aswing.ASColor;
import GUI.fox.aswing.ASTextFormat;
import GUI.fox.aswing.GridLayout;
import GUI.fox.aswing.Icon;
import GUI.fox.aswing.JButton;
import GUI.fox.aswing.JCheckBox;
import GUI.fox.aswing.JFrame;
import GUI.fox.aswing.JPanel;
import GUI.fox.aswing.JSeparator;
import GUI.fox.aswing.JSlider;
import GUI.fox.aswing.JTextField;
import GUI.fox.aswing.SoftBoxLayout;
import GUI.fox.aswing.border.BevelBorder;
import com.GameInterface.DistributedValueBase;
import com.GameInterface.Game.Character;
import com.fox.CCC.BodyParts;
import com.fox.CCC.Mod;
import flash.geom.Point
	
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
	private function GetMultiLength(array:Array){
		var i = 0
		for (var y in array[1]){
			i += array[1][y].length
		}
		return i-1
	}
	private function GetMultiArrayItem(array, index){
		for (var y:Number = 0; y < array[0].length;y++){
			if (index > array[1][y].length-1){
				index -= array[1][y].length
			}else{
				return [array[0][y], array[1][y][index]]
			}
		}
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
private function SerializeLooks(){
		
		var serialized:Array = [];
		
		var part = BodyParts.Head[sex]
		var package_idx = Math.round(sliders[BodyParts.e_Head].getValue());
		var look_Idx = Math.round(sliders[BodyParts.e_Face].getValue());
		var key = GetKeyByIndex(part, package_idx);
		serialized.push([Number(key), part[key][look_Idx]].join(","));
		
		
		part = BodyParts.Hair[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[BodyParts.e_Hair].getValue());
		key = GetKeyByIndex(part, 0);
		serialized.push([Number(key), part[key][look_Idx]].join(","));
		
		
		part = BodyParts.Hair_Color;
		var values = GetMultiArrayItem(part, Math.round(sliders[BodyParts.e_Hair_Color].getValue()));
		serialized.push([values[0], values[1]].join(","));
		
		part = BodyParts.Eye_Color;
		values = GetMultiArrayItem(part, Math.round(sliders[BodyParts.e_Eye_Color].getValue()));
		serialized.push([values[0], values[1]].join(","));
		
		part = BodyParts.Eyebrow_Color;
		package_idx = 0;
		look_Idx = Math.round(sliders[BodyParts.e_Eyebrow_Color].getValue());
		key = GetKeyByIndex(part, package_idx);
		serialized.push([Number(key), part[key][look_Idx]].join(","));
		
		
		
		part = BodyParts.Facial_Details[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[BodyParts.e_Facial_Detail].getValue());
		if (look_Idx != 0){
			key = GetKeyByIndex(part, package_idx);
			serialized.push([Number(key), part[key][look_Idx]].join(","));
			
		}
		
		part = BodyParts.Facial_Hair[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[BodyParts.e_Facial_Hair].getValue());
		key = GetKeyByIndex(part, package_idx);
		serialized.push([Number(key), part[key][look_Idx]].join(","));
		
		
		part = BodyParts.Facial_Hair_Color[sex];
		package_idx = 0;
		look_Idx = Math.round(sliders[BodyParts.e_Facial_Hair_Color].getValue());
		if (look_Idx != 0){
			key = GetKeyByIndex(part, package_idx);
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		part = BodyParts.Makeup[sex];
		package_idx = Math.round(sliders[BodyParts.e_Makeup].getValue());
		if (package_idx != 0){
			look_Idx = Math.round(sliders[BodyParts.e_Makeup_Type].getValue());
			key = OrderedObject(part, package_idx);
			serialized.push([Number(key), part[key][look_Idx]].join(","));
		}
		
		m_Mod.s_SerializedLook = serialized.join(";");
		if (m_Mod.d_Enabled.GetValue()) m_Mod.ApplyLooks();
	}
	
	private function GetSliders():JPanel{
		if (SliderPanel == undefined){
			SliderPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
			
			sliders = [
				new JSlider(JSlider.HORIZONTAL, 0, GetLength(BodyParts.Head[sex]), 0), // Head
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(BodyParts.Head[sex]), 0), // Face
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(BodyParts.Hair[sex])-1, 0), // Hair
				new JSlider(JSlider.HORIZONTAL, 0, GetMultiLength(BodyParts.Hair_Color), 0), // Hair Color
				new JSlider(JSlider.HORIZONTAL, 0, GetMultiLength(BodyParts.Eye_Color), 0), // Eye Color
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(BodyParts.Eyebrow_Color)-1, 0), // Eyebrow Color
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(BodyParts.Facial_Details[sex]) - 1, 0), // Facial Detail
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(BodyParts.Facial_Hair[sex])-1, 0), // Facial Hair / Eye brow shape
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(BodyParts.Facial_Hair_Color[sex])-1, 0), // Facial Hair Color
				new JSlider(JSlider.HORIZONTAL, 0, GetLength(BodyParts.Makeup[sex])+1, 0), // Makeup
				new JSlider(JSlider.HORIZONTAL, 0, GetSubLength(BodyParts.Makeup[sex]), 0) // Var
			];
			sliders[BodyParts.e_Head].addChangeListener(__HeadChanged, this);
			sliders[BodyParts.e_Face].addChangeListener(__FaceChanged, this);
			sliders[BodyParts.e_Hair].addChangeListener(__HairChanged, this);
			sliders[BodyParts.e_Hair_Color].addChangeListener(__HairColorChanged, this);
			sliders[BodyParts.e_Eye_Color].addChangeListener(__EyeColorChanged, this);
			sliders[BodyParts.e_Eyebrow_Color].addChangeListener(__EyeBrowColorChanged, this);
			sliders[BodyParts.e_Facial_Detail].addChangeListener(__FacialDetailChanged, this);
			sliders[BodyParts.e_Facial_Hair].addChangeListener(__FacialHairChanged, this);
			sliders[BodyParts.e_Facial_Hair_Color].addChangeListener(__FacialHairColorChanged, this);
			sliders[BodyParts.e_Makeup].addChangeListener(__MakeupChanged, this);
			sliders[BodyParts.e_Makeup_Type].addChangeListener(__MakeupVarChanged, this);
			for (var i:Number = 0; i < sliders.length;i++){
				sliders[i].setSnapToTicks(true);
				sliders[i].setMinorTickSpacing(1);
				sliders[i].setFocusable(false);
			}
			
			Tfs = [
				new JTextField("Head 0", 20),
				new JTextField("Face 0", 20),
				new JTextField("Hair 0", 20),
				new JTextField("Hair Color 0", 20),
				new JTextField("Eye Color 0", 20),
				new JTextField("Eyebrow Color 0", 20),
				new JTextField("Detail 0", 20),
				new JTextField("Detail2 0", 20),
				new JTextField("Detail Color 0", 20),
				new JTextField("Makeup 0", 20),
				new JTextField("Color 0", 20)
			];
			for (var i:Number = 0; i < Tfs.length;i++){
				Tfs[i].setEditable(false);
				Tfs[i].setFocusable(false);
				Tfs[i].setBorder(null);
				Tfs[i].setEnabled(false);
			}
			for (var i:Number = 0; i < sliders.length; i++){
				var subPane:JPanel = new JPanel(new GridLayout(1, 2));
				subPane.append(sliders[i]);
				subPane.append(Tfs[i]);
				SliderPanel.append(subPane);
				if (i == 1 || i == 3 || i == 5 || i == 8){
					SliderPanel.append(new JSeparator());
				}
			}
		}
		return SliderPanel
	}
	private function GetCheckboxes():JPanel {
		var CheckboxPane:JPanel = new JPanel();
		CheckboxPane.append(GetEnableCheckbox());
		CheckboxPane.append(GetDisableIdleCheckbox());
		return CheckboxPane
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
		
		sliders[BodyParts.e_Head].setValue(values[BodyParts.e_Head]);
		sliders[BodyParts.e_Face].setValue(values[BodyParts.e_Face]);
		sliders[BodyParts.e_Hair].setValue(values[BodyParts.e_Hair]);
		sliders[BodyParts.e_Hair_Color].setValue(values[BodyParts.e_Hair_Color]);
		sliders[BodyParts.e_Eye_Color].setValue(values[BodyParts.e_Eye_Color]);
		sliders[BodyParts.e_Facial_Detail].setValue(values[BodyParts.e_Facial_Detail]);
		sliders[BodyParts.e_Eyebrow_Color].setValue(values[BodyParts.e_Eyebrow_Color]);
		sliders[BodyParts.e_Facial_Hair].setValue(values[BodyParts.e_Facial_Hair]);
		sliders[BodyParts.e_Facial_Hair_Color].setValue(values[BodyParts.e_Facial_Hair_Color]);
		sliders[BodyParts.e_Makeup].setValue(values[BodyParts.e_Makeup]);
		sliders[BodyParts.e_Makeup_Type].setValue(values[BodyParts.e_Makeup_Type]);
	}
//Slider actions
	private function __HeadChanged(slider:JSlider){
		var val =  Math.round(slider.getValue());
		Tfs[BodyParts.e_Head].setText("Head " + val);
		var key = GetKeyByIndex(BodyParts.Head[sex], val);
		sliders[BodyParts.e_Face].setMaximum(BodyParts.Head[sex][key].length - 1);
		if (sliders[BodyParts.e_Face].getMaximum() == 0){
			sliders[BodyParts.e_Face].setEnabled(false);
		}else{
			sliders[BodyParts.e_Face].setEnabled(true);
		}
		if (sliders[BodyParts.e_Face].getValue() == 0){
			__FaceChanged(sliders[BodyParts.e_Face]);
			return
		}
		sliders[BodyParts.e_Face].setValue(0);
	}
	private function __FaceChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Face].setText("Face " + val);
		SerializeLooks();
	}
	private function __HairChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Hair].setText("Hair " + val);
		SerializeLooks();
	}
	private function __HairColorChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Hair_Color].setText("Hair Color " + val);
		SerializeLooks();
	}
	private function __EyeBrowColorChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Eyebrow_Color].setText("Eyebrow Color " + val);
		SerializeLooks();
	}
	private function __FacialDetailChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Facial_Detail].setText("Detail " + val);
		SerializeLooks();
	}
	private function __FacialHairChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Facial_Hair].setText("Detail2 " + val);
		SerializeLooks();
	}
	private function __FacialHairColorChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Facial_Hair_Color].setText("Detail Color " + val);
		SerializeLooks();
	}
	private function __EyeColorChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Eye_Color].setText("Eye Color " + val);
		SerializeLooks();
	}
	private function __MakeupChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Makeup].setText("Makeup " + val);
		var key = OrderedObject(BodyParts.Makeup[sex], val);
		sliders[BodyParts.e_Makeup_Type].setMaximum(BodyParts.Makeup[sex][key].length - 1);
		if (sliders[BodyParts.e_Makeup_Type].getMaximum() == 0){
			sliders[BodyParts.e_Makeup_Type].setEnabled(false);
		}else{
			sliders[BodyParts.e_Makeup_Type].setEnabled(true);
		}
		if (sliders[BodyParts.e_Makeup_Type].getValue() == 0){
			__MakeupVarChanged(sliders[BodyParts.e_Makeup_Type]);
			return
		}
		sliders[BodyParts.e_Makeup_Type].setValue(0);
	}
	private function __MakeupVarChanged(slider:JSlider){
		var val = Math.round(slider.getValue());
		Tfs[BodyParts.e_Makeup_Type].setText("Color " + val);
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