package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ListBase;
    import com.viburnum.events.ListEvent;
    import com.viburnum.utils.LayoutUtil;
    
    public class List extends ListBase
    {
		private var _scroller:Scroller;
		private var _allowMultipleSelection:Boolean = false;

        public function List()
        {
            super();
        }
		
		public function set selectedItems(value:Array):void
		{
		}
		
		public function get selectedItems():Array
		{
			return null;
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_scroller = new Scroller();
			addChild(_scroller);

			//myContentGroup会被添加到_scroller中
			myContentGroup.percentWidth = 1;
			_scroller.viewport = myContentGroup;
		}
		
		override protected function onInitializeComplete():void
		{
			super.onInitializeComplete();
			
			addEventListener(ListEvent.ITEM_RENDER_CLICK, itemRenderClickHandler);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;

			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;

			var left:Number = pl + bl;
			var top:Number = pt + bt;
			var right:Number = pr + br;
			var bottom:Number = pb + bb;
			
			var contenWidth:Number = layoutWidth - left - right;
			var contenHeight:Number = layoutHeight - top - bottom;
			
			LayoutUtil.setDisplayObjectLayout(_scroller, 
				left, top, contenWidth, contenHeight);
		}
		
		protected function itemRenderClickHandler(event:ListEvent):void
		{
			var render:IItemRender = event.itemRender;
			if(render != null)
			{
				selectedIndex = render.itemIndex;
			}
		}
    }
}