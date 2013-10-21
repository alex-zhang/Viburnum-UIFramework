package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.Container;
	import com.viburnum.components.HDividedContainer;
	import com.viburnum.components.HGroup;
	import com.viburnum.components.VDividedContainer;
	import com.viburnum.components.VGroup;
	import com.viburnum.layouts.VerticalLayout;
	import com.viburnum.skins.DefaultBackgroundSkin;
	
	import flash.events.MouseEvent;

	public class H2VDividedContainerTest extends ComponentTestBase
	{
		public function H2VDividedContainerTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			componentContainer.layout = new VerticalLayout();
			
			addhdvider();
			addvdvider();
			
			description = "liveDragging 功能尚有问题,移动限制的边界检查尚有问题";
		}
		
		private function addhdvider():void
		{
			var hd:HDividedContainer = new HDividedContainer();
			hd.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			hd.percentWidth = 1;
			hd.percentHeight = 1;
			
			var page1:Container = new Container();
			page1.name = "page1";
			hd.percentWidth = 1;
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
			
			hd.addViewPage(page1);
			hd.addViewPage(page2);
			hd.addViewPage(page3);
			hd.addViewPage(page4);
			
			componentContainer.addChild(hd);
		}
		
		private function addvdvider():void
		{
			var vd:VDividedContainer = new VDividedContainer();
			vd.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			vd.percentWidth = 1;
			vd.percentHeight = 1;

			var page1:Container = new Container();
			page1.percentWidth = 1;
			page1.percentHeight = 1;
			page1.name = "page1";
			page1.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			var page2:Container = new Container();
			page2.name = "page2";
			page2.percentWidth = 1;
			page2.height = 30;
			page2.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			var page3:Container = new Container();
			page3.name = "page3";
			page3.percentWidth = 1;
			page3.percentHeight = 1;
			page3.setStyle("backgroundSkin_backgroundColor", Math.random() * uint.MAX_VALUE);
			
			vd.addViewPage(page1);
			vd.addViewPage(page2);
			vd.addViewPage(page3);
			
			componentContainer.addChild(vd);
		}
	}
}