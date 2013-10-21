package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.HGroup;
	import com.viburnum.components.Label;
	import com.viburnum.components.TextInput;
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TextTest extends ComponentTestBase
	{
		public function TextTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var hg:HGroup = new HGroup();
			componentContainer.addChild(hg);
			
			var label:Label = new Label();
			label.name = "labelTTT";
			label.setStyle("textAlign", "center");
			label.width = 300;
			label.text = "Label";
			hg.addChild(label);
			
			var textInput:TextInput = new TextInput();
			textInput.text = "TextInput";
			hg.addChild(textInput);
			
//			var baseText:TextField = new TextField();
//			baseText.type = TextFieldType.INPUT;
//			baseText.width = 250;
//			baseText.border = true;
//			
//			var f:TextFormat = new TextFormat();
//			f.color = 0xFF0000;
//			f.align = TextFormatAlign.CENTER;
//			baseText.setTextFormat(f);
//			baseText.text = "asdasdasd";
//			hg.addChild(baseText);
		}
	}
}