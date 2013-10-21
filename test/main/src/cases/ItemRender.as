package cases
{
	import com.viburnum.components.SWFLoader;
	import com.viburnum.components.ItemRender;

	public class ItemRender extends ItemRender
	{
		public function ItemRender()
		{
			super();
			
			percentWidth = 1;
		}
		
		private var _img:SWFLoader;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_img = new SWFLoader();
			addContentChild(_img);
		}
		
		override protected function dataChanged():void
		{
			super.dataChanged();
			
			var r:int = int(data);
			if(r % 2 == 0)
			{
				_img.source = AssetsReference.assets3;
			}
			else
			{
				_img.source = AssetsReference.assets5;
			}
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			graphics.clear();
			graphics.beginFill(0xFFF000);
			graphics.drawRect(0, 0, layoutWidth, layoutHeight);
			graphics.endFill();
		}
	}
}