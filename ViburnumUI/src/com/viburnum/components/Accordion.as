package com.viburnum.components
{
	import com.viburnum.components.baseClasses.ContainerBase;
	import com.viburnum.components.baseClasses.MutiSelectableViewPageBase;
	import com.viburnum.components.supportClasses.AccordionTitleBar;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	[Style(name="accordionTitleBar_styleName", type="String")]
	
    public class Accordion extends MutiSelectableViewPageBase
    {
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"accordionTitleBar_styleName", type:"String"},			
				]
		}
		
		protected var _accordionTitleBars:Array = [];//AccordionTitleBarBase

        public function Accordion()
        {
            super();

			myContentGroup = new VGroup();
			VGroup(myContentGroup).gap = 0;
        }
		
		public function getAccordionTitleBarByIndex(index:int):AccordionTitleBar
		{
			return _accordionTitleBars[index];
		}
		
		override public function addViewPageAt(viewPage:ContainerBase, index:int):void
		{
			if(viewPage == null || containViewPage(viewPage)) return;
			var n:int = getViewPageCount();
			if(index < 0 || index > n) return;
			
			super.addViewPageAt(viewPage, index);
			
			viewPage.includeInLayout = false;
			viewPage.setVisible(false);
			
			var accordionTitleBar:AccordionTitleBar = createAccordionTitleBarByIndex(index);
			if(accordionTitleBar != null)
			{
				addAccordionTitleBar(accordionTitleBar, index);	
			}
			
			ajustViewPagesAndAccordionTitleBars();
		}

		override public function removeViewPageAt(index:int):void
		{
			var n:int = getViewPageCount();
			if((n == 0 && index != 0) || (index < 0 || index > n -1)) return;
			
			var viewPage:ContainerBase = getViewPageAt(index);
			if(viewPage == null || !containViewPage(viewPage)) return;

			super.removeViewPageAt(index);

			viewPage.includeInLayout = true;
			viewPage.setVisible(true);

			var accordionTitleBar:AccordionTitleBar = getAccordionTitleBarByIndex(index);
			if(accordionTitleBar != null)
			{
				removeAccordionTitleBar(accordionTitleBar, index);
			}
			
			ajustViewPagesAndAccordionTitleBars();
		}
		
		private function ajustViewPagesAndAccordionTitleBars():void
		{
			for(var i:int = 0, n:int = myContentGroup.numChildren; i < n; i++)
			{
				var isViewPageIndex:Boolean = i % 2 != 0;
				var child:DisplayObject;
				
				if(isViewPageIndex)
				{
					var viewPageIndex:int = (i - 1) / 2;
					child = getViewPageAt(viewPageIndex);
				}
				else
				{
					var dividerBtnIndex:int = i / 2;
					child = getAccordionTitleBarByIndex(dividerBtnIndex);
				}
				
				LayoutUtil.setDisplayObjectChildIndex(this, child, i);
			}
		}
		
		protected function createAccordionTitleBarByIndex(viewPageIndex:int):AccordionTitleBar
		{
			var accordionTitleBar:AccordionTitleBar = new AccordionTitleBar();
			accordionTitleBar.percentWidth = 1;
			accordionTitleBar.height = 30;
			
			return accordionTitleBar;
		}
		
		protected function addAccordionTitleBar(accordionTitleBar:AccordionTitleBar, index:int):void
		{
			if(accordionTitleBar == null) return;
			
			_accordionTitleBars.splice(index, 0, accordionTitleBar);
			
			accordionTitleBar.addEventListener(MouseEvent.CLICK, accordionTitleBarClickHandler);
			accordionTitleBar.styleName = getStyle("accordionTitleBar_styleName");
			myContentGroup.addChild(accordionTitleBar);
		}
		
		private function regenerateAllAccordionTitleBarsStyle():void
		{
			for(var i:uint = 0, n:uint = _accordionTitleBars.length; i < n; i++)
			{
				var accordionTitleBar:AccordionTitleBar = _accordionTitleBars[i];
				accordionTitleBar.styleName = getStyle("accordionTitleBar_styleName");
			}
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "accordionTitleBar_styleName")
			{
				regenerateAllAccordionTitleBarsStyle();
			}
		}
		
		protected function removeAccordionTitleBar(accordionTitleBar:AccordionTitleBar, index:int):void
		{
			if(accordionTitleBar == null) return;
			
			_accordionTitleBars.splice(index, 1);
			accordionTitleBar.removeEventListener(MouseEvent.CLICK, accordionTitleBarClickHandler);
			
			myContentGroup.removeChild(accordionTitleBar);
		}

		protected function accordionTitleBarClickHandler(event:MouseEvent):void
		{
			var targetAccordionTitleBar:AccordionTitleBar = event.currentTarget as AccordionTitleBar;
			var accordionTitleBarIndex:int = _accordionTitleBars.indexOf(targetAccordionTitleBar);
			
			selectedIndex = accordionTitleBarIndex;
		}
		
		override protected function pageViewSelected(lastSelectedIndex:int, currentSelectedIndex:int):void
		{
			if(lastSelectedIndex == currentSelectedIndex) return;
			
			var lastSelectedPage:ContainerBase = getViewPageAt(lastSelectedIndex);
			if(lastSelectedPage != null)
			{
				lastSelectedPage.setVisible(false);	
				lastSelectedPage.includeInLayout = false;
			}
			
			var lastAccordionTitleBar:AccordionTitleBar = getAccordionTitleBarByIndex(lastSelectedIndex);
			if(lastAccordionTitleBar != null)
			{
				lastAccordionTitleBar.selected = false;
			}
			
			var currentSelectedPage:ContainerBase = getViewPageAt(currentSelectedIndex);
			if(currentSelectedPage != null)
			{
				currentSelectedPage.setVisible(true);
				currentSelectedPage.includeInLayout = true;
			}
			
			var currentAccordionTitleBar:AccordionTitleBar = getAccordionTitleBarByIndex(currentSelectedIndex);
			if(currentAccordionTitleBar != null)
			{
				currentAccordionTitleBar.selected = true;
			}
		}
    }
}