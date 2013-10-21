package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.CheckBox;
	import com.viburnum.components.HGroup;
	import com.viburnum.components.HSlider;
	import com.viburnum.components.NumericStepper;
	import com.viburnum.components.RadioButton;
	import com.viburnum.components.RadioButtonGroup;
	import com.viburnum.components.Spinner;
	import com.viburnum.components.VSlider;
	import com.viburnum.layouts.FlowLayout;
	import com.viburnum.layouts.VerticalLayout;
	
	import flash.events.MouseEvent;

	public class ButtonControlTest extends ComponentTestBase
	{
		public function ButtonControlTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			componentContainer.layout = new FlowLayout();
			
			var c:CheckBox = new CheckBox();
			c.label = "normal CheckBox";
			componentContainer.addChild(c);
			
			var c1:CheckBox = new CheckBox();
			c1.selected  = true;
			c1.enabled = false;
			c.label = "enabled selected CheckBox";
			componentContainer.addChild(c1);
			
			var rg:RadioButtonGroup = new RadioButtonGroup();
			for(var i:uint = 0; i < 3; i++)
			{
				var r:RadioButton = new RadioButton();
				r.group = rg;
				componentContainer.addChild(r);
			}
			
			var rb2:RadioButton = new RadioButton();
			rb2.enabled = false;
			rb2.selected = true;
			rb2.label = "enabled selected RadioButton";
			componentContainer.addChild(rb2);
			//--

			var hslider:HSlider = new HSlider();
			hslider.stepSize = 1/3;
			hslider.snapInterval = 20;
			hslider.minimum = 20;
			hslider.maximum = 100;
			hslider.value = 30;

			var vslider:VSlider = new VSlider();
			vslider.textFormatFunction = slidertextFormatFunction;
			vslider.value = 50;
			vslider.minimum = 20;
			vslider.maximum = 100;

			componentContainer.addChild(hslider);
			componentContainer.addChild(vslider);

			var s:Spinner = new Spinner();
			componentContainer.addChild(s);
			
			var numericStepper:NumericStepper = new NumericStepper();
			numericStepper.textFormatFunction = numericSteppertextFormatFunction;
			componentContainer.addChild(numericStepper);
		}
		
		private function numericSteppertextFormatFunction(value:Number):String
		{
			var s:String = value.toString();
			s += "单位";
			
			return s;
		}
		
		private function slidertextFormatFunction(value:Number):String
		{
			var s:String = value.toString();
			s += "单位";
			
			return s;
		}
	}
}