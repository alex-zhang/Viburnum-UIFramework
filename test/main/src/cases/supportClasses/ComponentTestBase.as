package cases.supportClasses
{
	import com.viburnum.components.BorderContainer;
	import com.viburnum.components.Button;
	import com.viburnum.components.Container;
	import com.viburnum.components.Group;
	import com.viburnum.components.HGroup;
	import com.viburnum.components.Label;
	import com.viburnum.core.CSSStyleDeclaration;
	import com.viburnum.layouts.HorizontalLayout;
	import com.viburnum.layouts.TileLayout;
	import com.viburnum.layouts.VerticalLayout;
	import com.viburnum.skins.DefaultBorderSkin;
	
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	public class ComponentTestBase extends BorderContainer
	{
		public var textViewButton:Button;
		
		private var _textFied:Label;
		protected var componentContainer:Group;
		protected var controlContainer:HGroup;

		private var _description:String;
		private var _descriptionChnagedFlag:Boolean = false;
		
		public function ComponentTestBase()
		{
			super();

			percentWidth = 1;
			percentHeight = 1;
			
			var layoutTarget:VerticalLayout = new VerticalLayout();
			layoutTarget.paddingLeft = 10;
			layoutTarget.paddingRight = 10;
			layoutTarget.paddingTop = 10;
			layoutTarget.paddingBottom = 10;
			
			contentGroup.layout = layoutTarget

			initComponent();
		}
		
		public function set description(value:String):void
		{
			_description = value;
			_descriptionChnagedFlag = true;
			invalidateProperties();
		}

		private function initComponent():void
		{
			textViewButton = new Button();
			var s:String = getQualifiedClassName(this);
			var sr:Array = s.split("::");
			s = sr.length > 1 ? sr[1] : sr[0];
			
			textViewButton.label = s;
			textViewButton.addEventListener(MouseEvent.CLICK, testClickHandler); 
			
			ViburnumBootStrapMain.getInstance().addTestListButon(textViewButton);
		}

		protected function testClickHandler(event:MouseEvent):void
		{
			ViburnumBootStrapMain.getInstance().showTestView(this);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			
			_textFied = new Label();
			addContentChild(_textFied);
			
			componentContainer = new HGroup();
			componentContainer.percentWidth = 1;
			componentContainer.percentHeight = 1;
			
			addContentChild(componentContainer);
			
			controlContainer = new HGroup();
			controlContainer.percentWidth = 1;

			addContentChild(controlContainer);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(_descriptionChnagedFlag)
			{
				_descriptionChnagedFlag = false;
				
				_textFied.htmlText = _description;
			}
		}
	}
}