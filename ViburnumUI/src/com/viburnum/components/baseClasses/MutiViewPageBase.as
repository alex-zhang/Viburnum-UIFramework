package com.viburnum.components.baseClasses
{
	import com.viburnum.components.Group;
	import com.viburnum.utils.LayoutUtil;

    public class MutiViewPageBase extends ContainerBase
    {
		private var _viewPages:Array = []

        public function MutiViewPageBase()
        {
            super();
        }

		public function getViewPageCount():int
		{
			return _viewPages.length;
		}
		
		public function getViewPageAt(index:int):ContainerBase
		{
			return _viewPages[index];
		}
		
		public function getViewPageIndex(viewPage:ContainerBase):int
		{
			return _viewPages.indexOf(viewPage);
		}

		public function addViewPageAt(viewPage:ContainerBase, index:int):void
		{
			if(viewPage == null || containViewPage(viewPage)) return;
			var n:int = getViewPageCount();
			if(index < 0 || index > n) return;

			if(isNaN(viewPage.explicitWidth) && isNaN(viewPage.percentWidth)) viewPage.percentWidth = 1;
			if(isNaN(viewPage.explicitHeight) && isNaN(viewPage.percentHeight)) viewPage.percentHeight = 1;
				
			_viewPages.splice(index, 0, viewPage);
			
			myContentGroup.addChild(viewPage);
		}

		public function removeViewPageAt(index:int):void
		{
			var n:int = getViewPageCount();
			if((n == 0 && index != 0) || (index < 0 || index > n -1)) return;
			var viewPage:ContainerBase = getViewPageAt(index);
			if(viewPage == null || !containViewPage(viewPage)) return;

			_viewPages.splice(index, 1);
			myContentGroup.removeChild(viewPage);
		}
		
		public function addViewPage(viewPage:ContainerBase):void
		{
			addViewPageAt(viewPage, getViewPageCount());
		}
		
		public function removeViewPage(viewPage:ContainerBase):void
		{
			removeViewPageAt(getViewPageIndex(viewPage));
		}
		
		public function removeAllViewPage():void
		{
			_viewPages.splice(0, -1);
			Group(myContentGroup).removeChildren();
		}

		public function getAllViewPages():Array
		{
			return _viewPages.concat();
		}

		public function containViewPage(viewPage:ContainerBase):Boolean
		{
			return getViewPageIndex(viewPage) != -1 && myContentGroup.contains(viewPage);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var myContentGroupMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(myContentGroup);
			var myContentGroupMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(myContentGroup);
			
			var measuredW:Number = Math.max(this.measuredWidth, myContentGroupMW);
			var measuredH:Number = Math.max(this.measuredHeight, myContentGroupMH);
			
			setMeasuredSize(measuredW, measuredH);
			
			//--
			
			var measuredMinW:Number = LayoutUtil.getDisplayObjectMinWidth(myContentGroup);
			var measuredMinH:Number = LayoutUtil.getDisplayObjectMinHeight(myContentGroup);
			
			setMeasuredMinSize(measuredMinW, measuredMinH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			LayoutUtil.setDisplayObjectSize(myContentGroup, layoutWidth, layoutHeight);
		}
    }
}