package cases
{
	import com.viburnum.components.Group;
	import com.viburnum.components.SWFLoader;
	import com.viburnum.components.Scroller;
	import cases.supportClasses.ComponentTestBase;

	public class ScrollerTest extends ComponentTestBase
	{
		public function ScrollerTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		
			var g:Group = new Group();
			var swf:SWFLoader = new SWFLoader();
			swf.maintainAspectRatio = false;
			swf.source = "back002.jpg";
			g.addChild(swf);
			
			var s:Scroller = new Scroller();
			s.percentWidth = 1;
			s.percentHeight = 1;
			s.viewport = g;
			componentContainer.addChild(s);
		}
	}
}