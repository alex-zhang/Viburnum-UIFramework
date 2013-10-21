package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.DataGroup;
	import com.viburnum.components.List;
	import com.viburnum.components.Scroller;
	import com.viburnum.components.supportClasses.DateChooserDayItemRender;
	import com.viburnum.core.ClassFactory;
	import com.viburnum.data.ArrayList;
	import com.viburnum.layouts.VerticalLayout;

	public class DataGroupTest extends ComponentTestBase
	{
		public function DataGroupTest()
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

			var dataGroup:DataGroup = new DataGroup();
			dataGroup.percentWidth = 1;
			dataGroup.percentHeight = 1;
			dataGroup.dataProvider = datap;
			dataGroup.itemRenderer = new ClassFactory(DateChooserDayItemRender, {percentWidth:1});
			
			componentContainer.addChild(dataGroup);
		}
	}
}