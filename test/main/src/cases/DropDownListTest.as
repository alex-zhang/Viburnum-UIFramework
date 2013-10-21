package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.CircleColorPicker;
	import com.viburnum.components.CircleColorPickerButton;
	import com.viburnum.components.ComboBox;
	import com.viburnum.components.DateField;
	import com.viburnum.components.DropDownList;
	import com.viburnum.components.PopUpButton;
	import com.viburnum.data.ArrayList;
	import com.viburnum.utils.ArrayUtil;
	import com.viburnum.utils.ColorUtil;
	
	import flash.events.MouseEvent;

	public class DropDownListTest extends ComponentTestBase
	{
		public function DropDownListTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var colorPicker:CircleColorPickerButton = new CircleColorPickerButton();
			colorPicker.dataProvider = new ArrayList(ColorUtil.getDefaultColorList());
			componentContainer.addChild(colorPicker);
			
			var comboBox:ComboBox = new ComboBox();
			componentContainer.addChild(comboBox);
			
			var dropDownList:DropDownList = new DropDownList();
			dropDownList.addEventListener(MouseEvent.CLICK, 
				function():void {popUpButton.enabled = !popUpButton.enabled;});
			componentContainer.addChild(dropDownList);
			
			var popUpButton:PopUpButton = new PopUpButton();
			componentContainer.addChild(popUpButton);
			
			var dateField:DateField = new DateField();
			componentContainer.addChild(dateField);
		}
	}
}