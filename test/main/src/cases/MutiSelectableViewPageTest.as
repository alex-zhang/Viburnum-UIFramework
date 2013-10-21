package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.Accordion;
	import com.viburnum.components.Button;
	import com.viburnum.components.Container;
	import com.viburnum.components.HGroup;
	import com.viburnum.components.Label;
	import com.viburnum.components.VGroup;
	import com.viburnum.components.ViewStack;
	import com.viburnum.layouts.VerticalLayout;
	
	import flash.events.MouseEvent;

	public class MutiSelectableViewPageTest extends ComponentTestBase
	{
		public function MutiSelectableViewPageTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			componentContainer.layout = new VerticalLayout();
			
			addViewStack();
			
			addVAccordion();
		}
		
		private function addViewStack():void
		{
			var text:Label = new Label();
			text.text = "ViewStack";
			componentContainer.addChild(text);
			
			var viewStackContainer:VGroup = new VGroup();
			viewStackContainer.percentWidth = 1;
			viewStackContainer.percentHeight = 1;
			componentContainer.addChild(viewStackContainer);
			
			var viewStack:ViewStack = new ViewStack();
			viewStack.percentWidth = 1;
			viewStack.percentHeight = 1;
			
			var page1:Container = new Container();
			page1.name = "page1";
			page1.percentWidth = 1;
			page1.percentHeight = 1;
			page1.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);

			var page2:Container = new Container();
			page2.name = "page2";
			page2.percentWidth = 1;
			page2.percentHeight = 1;
			page2.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			var page2Child:Container = new Container();
			page2Child.width = 30;
			page2Child.height = 30;
			page2Child.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			page2.addContentChild(page2Child);
			
			var page3:Container = new Container();
			page3.name = "page3";
			page3.percentWidth = 1;
			page3.percentHeight = 1;
			page3.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			var page4:Container = new Container();
			page4.name = "page4";
			page4.percentWidth = 1;
			page4.percentHeight = 1;
			page4.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			viewStack.addViewPage(page1);
			viewStack.addViewPage(page2);
			viewStack.addViewPage(page3);
			viewStack.addViewPage(page4);
			
			viewStackContainer.addChild(viewStack);
			
			var conrolHgroup:HGroup = new HGroup();
			conrolHgroup.percentWidth = 1;
			componentContainer.addChild(conrolHgroup);

			var pageBtn1:Button = new Button();
			pageBtn1.addEventListener(MouseEvent.CLICK, function():void {viewStack.selectedIndex = 0});
			pageBtn1.label = "page1";
			
			var pageBtn2:Button = new Button();
			pageBtn2.addEventListener(MouseEvent.CLICK, function():void {viewStack.selectedIndex = 1});
			pageBtn2.label = "page2";
			
			var pageBtn3:Button = new Button();
			pageBtn3.addEventListener(MouseEvent.CLICK, function():void {viewStack.selectedIndex = 2});
			pageBtn3.label = "page3";
			
			var pageBtn4:Button = new Button();
			pageBtn4.addEventListener(MouseEvent.CLICK, function():void {viewStack.selectedIndex = 3});
			pageBtn4.label = "page4";
			
			conrolHgroup.addChild(pageBtn1);
			conrolHgroup.addChild(pageBtn2);
			conrolHgroup.addChild(pageBtn3);
			conrolHgroup.addChild(pageBtn4);
		}
		
		private function addVAccordion():void
		{
			var text:Label = new Label();
			text.text = "VAccordion";
			componentContainer.addChild(text);
			
			var vaccordionContainer:VGroup = new VGroup();
			vaccordionContainer.percentWidth = 1;
			vaccordionContainer.percentHeight = 1;
			componentContainer.addChild(vaccordionContainer);
			
			var vaccordion:Accordion = new Accordion();
			vaccordion.percentWidth = 1;
			vaccordion.percentHeight = 1;
			
			var page1:Container = new Container();
			page1.name = "page1";
			page1.percentWidth = 1;
			page1.percentHeight = 1;
			page1.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			var page2:Container = new Container();
			page2.name = "page2";
			page2.percentWidth = 1;
			page2.percentHeight = 1;
			page2.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			var page2Child:Container = new Container();
			page2Child.width = 30;
			page2Child.height = 30;
			page2Child.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			page2.addContentChild(page2Child);
			
			var page3:Container = new Container();
			page3.name = "page3";
			page3.percentWidth = 1;
			page3.percentHeight = 1;
			page3.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			var page4:Container = new Container();
			page4.name = "page4";
			page4.percentWidth = 1;
			page4.percentHeight = 1;
			page4.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			vaccordion.addViewPage(page1);
			vaccordion.addViewPage(page2);
			vaccordion.addViewPage(page3);
			vaccordion.addViewPage(page4);
			
			vaccordionContainer.addChild(vaccordion);
			
			var conrolHgroup:HGroup = new HGroup();
			conrolHgroup.percentWidth = 1;
			componentContainer.addChild(conrolHgroup);
			
			var pageBtn1:Button = new Button();
			pageBtn1.addEventListener(MouseEvent.CLICK, function():void {vaccordion.selectedIndex = 0});
			pageBtn1.label = "page1";
			
			var pageBtn2:Button = new Button();
			pageBtn2.addEventListener(MouseEvent.CLICK, function():void {vaccordion.selectedIndex = 1});
			pageBtn2.label = "page2";
			
			var pageBtn3:Button = new Button();
			pageBtn3.addEventListener(MouseEvent.CLICK, function():void {vaccordion.selectedIndex = 2});
			pageBtn3.label = "page3";
			
			var pageBtn4:Button = new Button();
			pageBtn4.addEventListener(MouseEvent.CLICK, function():void {vaccordion.selectedIndex = 3});
			pageBtn4.label = "page4";
			
			conrolHgroup.addChild(pageBtn1);
			conrolHgroup.addChild(pageBtn2);
			conrolHgroup.addChild(pageBtn3);
			conrolHgroup.addChild(pageBtn4);
		}
	}
}