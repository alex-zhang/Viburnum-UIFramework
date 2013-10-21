package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.List;
	import com.viburnum.components.supportClasses.DateChooserDayItemRender;
	import com.viburnum.core.ClassFactory;
	import com.viburnum.data.ArrayList;

	public class ListTest extends ComponentTestBase
	{
		public function ListTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var arr:Array = [];
			var i:uint = 0;
			var n:uint = 500000;
			for(i = 0; i < n; i++)
			{
				arr.push(i);
			}
			
			var datap:ArrayList = new ArrayList(arr);
			
			var l:List = new List();
			l.selectedIndex = 1;
			
			l.percentWidth = 1;
			l.percentHeight = 1;
			l.dataProvider = datap;
			l.itemRenderer = new ClassFactory(DateChooserDayItemRender, {percentWidth:1});
			
			componentContainer.addChild(l);
		}
	}
}