package com.viburnum.components
{
    import com.viburnum.interfaces.IViewport;
    import com.viburnum.utils.LayoutUtil;
    
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
	
	[Style(name="horizontalScrollPolicy", type="String", enumeration="on,off,auto", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="verticalScrollPolicy", type="String", enumeration="on,off,auto", invalidateSize="true", invalidateDisplayList="true")]
	
	[Style(name="vScrollBar_styleName", type="String")]
	[Style(name="hScrollBar_styleName", type="String")]

    public final class Scroller extends SkinableComponent
    {
		private static const SDT:Number = 1.0;
		
		private var _invalidationCount:int = 0;
		
		private var _vScrollBar:VScrollBar;
		private var _hScrollBar:HScrollBar;

		private var _canScrollHorizontally:Boolean = false;
		private var _canScrollVertically:Boolean = false;
		
        private var _viewport:IViewport;
		private var _viewportChangedFlag:Boolean = false;
		
		private var _minViewportInset:Number = 0; 
		
		private var _measuredSizeIncludesScrollBars:Boolean = true;

        public function Scroller()
        {
            super();
        }

		public function get minViewportInset():Number
		{
			return _minViewportInset;
		}

		[Inspectable(type="Number", defaultValue="0")]
		public function set minViewportInset(value:Number):void
		{
			if(_minViewportInset != value)
			{
				_minViewportInset = value;
				invalidateSize();
				invalidateDisplayList();	
			}
		}

		public function get measuredSizeIncludesScrollBars():Boolean
		{
			return _measuredSizeIncludesScrollBars;
		}

		[Inspectable(type="Boolean")]
		public function set measuredSizeIncludesScrollBars(value:Boolean):void
		{
			if(_measuredSizeIncludesScrollBars == value) return;
			
			_measuredSizeIncludesScrollBars = value;
			
			invalidateSize();
			invalidateDisplayList();
		}   
		
        public function get viewport():IViewport
        {       
            return _viewport;
        }

        //viewport must be DisplayObject, viewport 可能不是该对象的child
        public function set viewport(value:IViewport):void
        {
			if(_viewport == value) return;

            if(_viewport != null)
            {
				_viewport.removeEventListener(MouseEvent.MOUSE_WHEEL, viewportMouseWheelHandler);

				if(_vScrollBar != null)
				{
					_vScrollBar.viewport = null;
				}
				
				if(_hScrollBar != null)
				{
					_hScrollBar.viewport = null;
				}
				
				if(_viewport is DisplayObject)
				{
					removeChild(DisplayObject(_viewport));
				}
				
				_viewport = null;
            }

            _viewport = value;

			if(_viewport != null)
			{
				_viewport.addEventListener(MouseEvent.MOUSE_WHEEL, viewportMouseWheelHandler);
				
				_viewport.clipAndEnableScrolling = true;
				
				if(_vScrollBar != null)
				{
					_vScrollBar.viewport = _viewport;
				}
				
				if(_hScrollBar != null)
				{
					_hScrollBar.viewport = _viewport;
				}

				if(_viewport is DisplayObject)
				{
					addChild(DisplayObject(_viewport));	
				}
			}

			_viewportChangedFlag = true;
			
			invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
		
        override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "vScrollBar_styleName")
			{
				_vScrollBar.styleName = getStyle("vScrollBar_styleName");
			}
			else if(styleProp == "hScrollBar_styleName")
			{
				_hScrollBar.styleName = getStyle("hScrollBar_styleName");
			}
		}
		
        override protected function onInitialize():void
        {
            super.onInitialize();

			_vScrollBar = new VScrollBar();
			_vScrollBar.viewport = _viewport;
			_vScrollBar.setVisible(false);
            addChild(_vScrollBar);

			_hScrollBar = new HScrollBar();
			_hScrollBar.viewport = _viewport;
			_hScrollBar.setVisible(false);
            addChild(_hScrollBar);
        }
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_viewportChangedFlag)
			{
				_viewportChangedFlag = false;

				_hScrollBar.enabled = false;
				_vScrollBar.enabled = false;
				_hScrollBar.setVisible(false);
				_vScrollBar.setVisible(false);
			}
		}
		
		//不支持viewport的百分比布局
        override protected function measure():void
        {
            super.measure();

			var padding:Number = _minViewportInset * 2;

			var measuredW:Number = padding;
            var measuredH:Number = padding;

			var minW:Number = padding;
			var minH:Number = padding;

			if(_viewport != null)
			{
				var isShowHScrollBar:Boolean = getStyle("horizontalScrollPolicy") == ScrollPolicy.ON;
				var isShowVScrollBar:Boolean = getStyle("verticalScrollPolicy") == ScrollPolicy.ON;

				var viewportMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_viewport);
				var viewportMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_viewport);
				
				measuredW += viewportMW;
				measuredH += viewportMH;
				
				if(_measuredSizeIncludesScrollBars)
				{
					if(isShowVScrollBar)
					{
						var vscrollBarMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_vScrollBar);
						measuredW += vscrollBarMW;
					}
					
					if(isShowHScrollBar)
					{
						var hscrollBarMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_hScrollBar);
						measuredH += hscrollBarMH;
					}
				}
			}
			
			setMeasuredSize(measuredW, measuredH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			if(_viewport == null) return;

			var padding:Number = _minViewportInset * 2;
			
			var viewableWidth:Number = layoutWidth - padding;
			var viewableHeight:Number = layoutHeight - padding;
			
			var viewPortW:Number = 0;
			var viewPortH:Number = 0;
			
			//-
			
			var viewPortPercentW:Number = LayoutUtil.getDisplayObjectPercentInWidth(_viewport);
			if(isNaN(viewPortPercentW))
			{
				viewPortW = LayoutUtil.getDisplayObjectMeasuredWidth(_viewport);
			}
			else
			{
				viewPortW = LayoutUtil.calculatePercentSizeInFullSize(viewPortPercentW, viewableWidth);
			}
			
			var viewPortPercentH:Number = LayoutUtil.getDisplayObjectPercentInHeight(_viewport);
			if(isNaN(viewPortPercentH))
			{
				viewPortH = LayoutUtil.getDisplayObjectMeasuredHeight(_viewport);
			}
			else
			{
				viewPortH = LayoutUtil.calculatePercentSizeInFullSize(viewPortPercentH, viewableHeight);
			}
			
			LayoutUtil.setDisplayObjectPosition(_viewport, _minViewportInset, _minViewportInset);
			
			//-

			var hscrollBarMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_hScrollBar);
			var vscrollBarMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_vScrollBar);

			var oldShowHSB:Boolean = _hScrollBar.visible;
			var oldShowVSB:Boolean = _vScrollBar.visible;
			
			var isAutoHScrollBar:Boolean = false;
			var isShowHScrollBar:Boolean = false;
			
			if(isNaN(viewPortPercentW))
			{
				var hScrollPolicy:String = getStyle("horizontalScrollPolicy");
				if(hScrollPolicy == ScrollPolicy.ON)
				{
					isShowHScrollBar = true;
				}
				else if(hScrollPolicy == ScrollPolicy.AUTO)
				{
					isAutoHScrollBar = true;
					isShowHScrollBar = viewPortW >= (viewableWidth + SDT);
				}
				else
				{
					isShowHScrollBar = false;
				}
				_canScrollHorizontally = isShowHScrollBar;
			}

			var isAutoVScrollBar:Boolean = false;
			var isShowVScrollBar:Boolean = false;
			
			if(isNaN(viewPortPercentH))
			{
				var vScrollPolicy:String = getStyle("verticalScrollPolicy");
				if(vScrollPolicy == ScrollPolicy.ON)
				{
					isShowVScrollBar = true;
				}
				else if(vScrollPolicy == ScrollPolicy.AUTO)
				{
					isAutoVScrollBar = true;
					isShowVScrollBar = viewPortH >= (viewableHeight + SDT);
				}
				else
				{
					isShowVScrollBar = false;
				}
				_canScrollVertically = isShowVScrollBar;
			}
			
			
			// Reset the viewport's width,height to account for the visible scrollbars, unless
			viewableWidth = (isShowVScrollBar && _measuredSizeIncludesScrollBars) ? layoutWidth - padding - vscrollBarMW : layoutWidth - padding;
			viewableHeight = (isShowHScrollBar && _measuredSizeIncludesScrollBars) ? layoutHeight - padding - hscrollBarMH : layoutHeight - padding;
			
			// If the scrollBarPolicy is auto, and we're only showing one scrollbar, 
			// the viewport may have shrunk enough to require showing the other one.
			
			var hsbIsDependent:Boolean = false;
			var vsbIsDependent:Boolean = false;
			
			if (isShowVScrollBar && !isShowHScrollBar && isAutoHScrollBar && (viewPortW >= (viewableWidth + SDT)))
			{
				isShowHScrollBar = hsbIsDependent = _canScrollHorizontally = true;
			}
			else if (!isShowVScrollBar && isShowHScrollBar && isAutoVScrollBar && (viewPortH >= (viewableHeight + SDT)))
			{
				isShowVScrollBar = vsbIsDependent = _canScrollVertically = true;
			}
			
			// If the HSB doesn't fit, hide it and give the space back.   Likewise for VSB.
			// If both scrollbars are supposed to be visible but they don't both fit, 
			// then prefer to show the "non-dependent" auto scrollbar if we added the second
			// "dependent" auto scrollbar because of the space consumed by the first.

			if(isShowHScrollBar && isShowVScrollBar) 
			{
				if(hsbFits(layoutWidth, layoutHeight) && vsbFits(layoutWidth, layoutHeight))
				{
					// Both scrollbars fit, we're done.
				}
				else if(!hsbFits(layoutWidth, layoutHeight, false) && !vsbFits(layoutWidth, layoutHeight, false))
				{
					// Neither scrollbar would fit, even if the other scrollbar wasn't visible.
					isShowHScrollBar = isShowVScrollBar = false;
				}
				else
				{
					// Only one of the scrollbars will fit.  If we're showing a second "dependent"
					// auto scrollbar because the first scrollbar consumed enough space to
					// require it, if the first scrollbar doesn't fit, don't show either of them.
					if(hsbIsDependent)
					{
						if(vsbFits(layoutWidth, layoutHeight, false))  // VSB will fit if HSB isn't shown   
						{
							isShowVScrollBar = false;
						}
						else 
						{
							isShowHScrollBar = isShowVScrollBar = false;
						}
					}
					else if(vsbIsDependent)
					{
						if(hsbFits(layoutWidth, layoutHeight, false)) // HSB will fit if VSB isn't shown
						{
							isShowVScrollBar = false;
						}
						else
						{
							isShowHScrollBar = isShowVScrollBar = false;
						}
					}
					else if(vsbFits(layoutWidth, layoutHeight, false)) // VSB will fit if HSB isn't shown
					{
						isShowHScrollBar = false;
					}
					else // hsbFits(w, h, false)   // HSB will fit if VSB isn't shown
					{
						isShowVScrollBar = false;	
					}
				}
			}
			else if(isShowHScrollBar && !hsbFits(layoutWidth, layoutHeight))  // just trying to show HSB, but it doesn't fit
			{
				isShowHScrollBar = false;
			}
			else if(isShowVScrollBar && !vsbFits(layoutWidth, layoutHeight))  // just trying to show VSB, but it doesn't fit
			{
				isShowVScrollBar = false;
			}
			
			// if the only reason for showing one particular scrollbar was because the 
			// other scrollbar was visible, and we're now not showing the other scrollbar, 
			// then there's no need to allow scrolling in that direction anymore.
			if(hsbIsDependent && !isShowVScrollBar)
			{
				_canScrollHorizontally = false;
			}

			if(vsbIsDependent && !isShowHScrollBar)
			{
				_canScrollVertically = false;
			}
			
			// Reset the viewport's width,height to account for the visible scrollbars, unless
			viewableWidth = (isShowVScrollBar && _measuredSizeIncludesScrollBars) ? 
				layoutWidth - padding - vscrollBarMW : 
				layoutWidth - padding;
			
			viewableHeight = (isShowHScrollBar && _measuredSizeIncludesScrollBars) ? 
				layoutHeight - padding - hscrollBarMH : 
				layoutHeight - padding;
			
			if(!isNaN(viewPortPercentW))
			{
				viewPortW = LayoutUtil.calculatePercentSizeInFullSize(viewPortPercentW, viewableWidth);
			}
			
			if(!isNaN(viewPortPercentH))
			{
				viewPortH = LayoutUtil.calculatePercentSizeInFullSize(viewPortPercentH, viewableHeight);
			}
			
			LayoutUtil.setDisplayObjectSize(_viewport, viewPortW, viewPortH);
			
			if(isShowHScrollBar)
			{
				var hScrollBarW:Number = isShowVScrollBar ? 
					layoutWidth - vscrollBarMW : 
					layoutWidth;
				
				LayoutUtil.setDisplayObjectLayout(_hScrollBar, 
					0, layoutHeight - hscrollBarMH, hScrollBarW, hscrollBarMH);
			}

			if(isShowVScrollBar)
			{
				var vScrollBarH:Number = isShowHScrollBar ? 
					layoutHeight - hscrollBarMH : 
					layoutHeight;
				
				LayoutUtil.setDisplayObjectLayout(_vScrollBar, 
					layoutWidth - vscrollBarMW, 0, vscrollBarMW, vScrollBarH);
			}
			
			LayoutUtil.setDisplayObjectVisiable(_hScrollBar, isShowHScrollBar);
			LayoutUtil.setDisplayObjectVisiable(_vScrollBar, isShowVScrollBar);
			
			_viewport.setViewableSize(viewableWidth, viewableHeight);
		}
		
		private function hsbFits(w:Number, h:Number, includeVSB:Boolean = true):Boolean
		{
			if (_vScrollBar.visible && includeVSB)
			{
				var vscrollBarMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_vScrollBar);
				var vscrollBarMinH:Number = LayoutUtil.getDisplayObjectMinHeight(_vScrollBar);

				w -= vscrollBarMW;
				h -= vscrollBarMinH;
			}

			var hscrollBarMinW:Number = LayoutUtil.getDisplayObjectMinWidth(_hScrollBar);
			var hscrollBarMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_hScrollBar);
			
			return (w >= hscrollBarMinW) && (h >= hscrollBarMH);
		}
		
		private function vsbFits(w:Number, h:Number, includeHSB:Boolean = true):Boolean
		{
			if (_hScrollBar.visible && includeHSB)
			{
				var hscrollBarMinW:Number = LayoutUtil.getDisplayObjectMinWidth(_hScrollBar);
				var hscrollBarMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_hScrollBar);
				
				w -= hscrollBarMinW;
				h -= hscrollBarMH;
			}
			
			var vscrollBarMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_vScrollBar);
			var vscrollBarMinH:Number = LayoutUtil.getDisplayObjectMinHeight(_vScrollBar);
			
			return (w >= vscrollBarMW) && (h >= vscrollBarMinH);
		}
		
		private function viewportMouseWheelHandler(event:MouseEvent):void
		{
			_vScrollBar.changeValueByStep(event.delta < 0);
		}
    }
}