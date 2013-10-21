package com.viburnum.components.baseClasses
{
	import com.viburnum.components.HDividedContainer;
	import com.viburnum.components.SimpleButton;
	import com.viburnum.events.ViburnumMouseEvent;
	import com.viburnum.interfaces.ILayoutElement;
	import com.viburnum.layouts.HorizontalLayout;
	import com.viburnum.layouts.VerticalLayout;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	[Style(name="dividerButton_StyleName", type="Class", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="divideIndicatorSkin", type="Class", skinClass="true", isDynamic="true")]
	[Style(name="dividerThickness", type="Number", format="Length")]
	[Style(name="dividerCursorSkin", type="Class")]
	
    public class DividedContainerBase extends MutiViewPageBase
    {
		public var divideIndicatorSkin:DisplayObject;

		protected var _dividerButtons:Array = [];//ButtonBase

		private var _isDividerBtnHoldedDraing:Boolean = false;
		private var _dividerBtnStartDragMousePostion:Number = 0;//MouseX or MouseY
		private var  _lastMouseDragPostion:Number = 0;
		private var _currentMouseMoveDirection:int = 0;//-1 leftTop 1 right Bottom
		private var _dividerBtnMoveDelta:Number = 0;
		private var _changeViewPagesSizeDividerIndex:int = -1;

		private var _requestPostionDivideIndicatorSkinByMoveDeltaFlag:Boolean = false;
		private var _changeViewPagesSizeByDividerDeltaChangedFlag:Boolean = false;

		private var _preSizeChangedChildrenSizeInfo:Array;//ChildSizeInfo
		
		private var _left2TopMoveableSizeLimitedByChildMinSize:Number = 0;
		private var _left2TopMoveableSizeLimitedByChildMaxSize:Number = 0;
		private var _right2BottonMoveableSizeLimitedByChildMinSize:Number = 0;
		private var _right2BottonMoveableSizeLimitedByChildMaxSize:Number = 0;
		
		private var _totalViewPagesPercentValue:Number = 0;
		
		private var _cursorDecoratorHandle:uint = 0;
		
        public function DividedContainerBase()
        {
            super();
        }

		private function requestPostionDivideIndicatorSkinByMoveDelta():void
		{
			if(!_isDividerBtnHoldedDraing) return;

			_requestPostionDivideIndicatorSkinByMoveDeltaFlag = true;
			invalidateDisplayList();
		}

		private function requestChangeViewPageSizeByMoveDelta():void
		{
			if(_dividerBtnMoveDelta == 0 || 
				_changeViewPagesSizeDividerIndex == -1) return;

			_changeViewPagesSizeByDividerDeltaChangedFlag = true;
			invalidateDisplayList();
		}

		override public function addViewPageAt(viewPage:ContainerBase, index:int):void
		{
			if(viewPage == null || containViewPage(viewPage)) return;
			var n:int = getViewPageCount();
			if(index < 0 || index > n) return;
			
			super.addViewPageAt(viewPage, index);

			if(n > 0)
			{
				createDividerButton(index);
			}
			
			ajustViewPagesAndDividerBtn();
		}
		
		private function createDividerButton(viewPageIndex:int):void
		{
			var dividerButton:ButtonBase = new SimpleButton();
			setDividerButtonDefaultSize(dividerButton);
			
			dividerButton.addEventListener(MouseEvent.MOUSE_DOWN, dividerButtonMouseDownHandler);
			dividerButton.addEventListener(ViburnumMouseEvent.BUTTON_ROLL_OVER, dividerButtonMouseRollOverHandler);
			dividerButton.addEventListener(ViburnumMouseEvent.BUTTON_ROLL_OUT, dividerButtonMouseRollOutHandler);
			dividerButton.addEventListener(ViburnumMouseEvent.BUTTON_HOLD_MOVE, dividerButtonHoldMoveHandler);
			dividerButton.addEventListener(ViburnumMouseEvent.BUTTON_HOLD_RELEASE, dividerButtonHoldReleaseHandler);
			dividerButton.styleName = getStyle("dividerButton_StyleName");
			
			var dividerBtnIndex:int = getDividerBtnIndexByPageViewIndex(viewPageIndex);
			_dividerButtons.splice(dividerBtnIndex, 0, dividerButton);
			
			myContentGroup.addChild(dividerButton);
		}
		
		private function destoryDividerButton(viewPageIndex:int):void
		{
			var dividerBtnIndex:int = getDividerBtnIndexByPageViewIndex(viewPageIndex);
			_dividerButtons.splice(dividerBtnIndex, 1);
			
			var dividerButton:ButtonBase = getDividerButtonAt(dividerBtnIndex);
			myContentGroup.removeChild(dividerButton);
			
			dividerButton.removeEventListener(MouseEvent.MOUSE_DOWN, dividerButtonMouseDownHandler);
			dividerButton.removeEventListener(ViburnumMouseEvent.BUTTON_ROLL_OVER, dividerButtonMouseRollOverHandler);
			dividerButton.removeEventListener(ViburnumMouseEvent.BUTTON_ROLL_OUT, dividerButtonMouseRollOutHandler);
			dividerButton.removeEventListener(ViburnumMouseEvent.BUTTON_HOLD_MOVE, dividerButtonHoldMoveHandler);
			dividerButton.removeEventListener(ViburnumMouseEvent.BUTTON_HOLD_RELEASE, dividerButtonHoldReleaseHandler);
		}
		
		private function ajustViewPagesAndDividerBtn():void
		{
			var n:int = myContentGroup.numChildren;
			for(var i:int = 0; i < n; i++)
			{
				var isViewPageIndex:Boolean = i % 2 == 0;
				var child:DisplayObject;
				if(isViewPageIndex)
				{
					var viewPageIndex:int = getViewPageIndexByChildIndex(i);
					child = getViewPageAt(viewPageIndex);
				}
				else
				{
					var dividerBtnIndex:int = getDividerIndexByChildIndex(i);
					child = getDividerButtonAt(dividerBtnIndex);
				}
				
				LayoutUtil.setDisplayObjectChildIndex(myContentGroup, child, i);
			}
		}
		
		private function getViewPageIndexByChildIndex(childIndex:int):int
		{
			var isViewPageIndex:Boolean = childIndex % 2 == 0;
			if(isViewPageIndex)
			{
				return childIndex / 2;
			}
			
			return -1;
		}
		
		private function getDividerIndexByChildIndex(childIndex:int):int
		{
			var isViewPageIndex:Boolean = childIndex % 2 == 0;
			if(!isViewPageIndex)
			{
				return (childIndex - 1) / 2;
			}
			
			return -1;
		}
		
		private function getDividerBtnIndexByPageViewIndex(index:int):int
		{
			return index - 1;
		}

		//调整viewpage的percent一确保百分比的child会填满整个空间
		private function adjustViewPagePercentSizeWhenViewPageAdd2Removed():void
		{
			if(_totalViewPagesPercentValue < 1)
			{
				var n:int = getViewPageCount();
				
				for(var i:int = 0; i < n; i++)
				{
					var viewPage:ContainerBase = getViewPageAt(i);
					
					var percentSize:Number = isHorizontal ? 
						LayoutUtil.getDisplayObjectPercentInWidth(viewPage) : 
						LayoutUtil.getDisplayObjectPercentInHeight(viewPage);

					if(!isNaN(percentSize))
					{
						if(isHorizontal)
						{
							viewPage.percentWidth = 1;
						}
						else
						{
							viewPage.percentHeight = 1;
						}
					}
				}
			}
		}

		override public function removeViewPageAt(index:int):void
		{
			var n:int = getViewPageCount();
			if((n == 0 && index != 0) || (index < 0 || index > n -1)) return;
			var viewPage:ContainerBase = getViewPageAt(index);
			if(viewPage == null || !containViewPage(viewPage)) return;

			var cacheSizeIndex:int = _preSizeChangedChildrenSizeInfo.indexOf(viewPage);
			if(cacheSizeIndex != -1) _preSizeChangedChildrenSizeInfo.splice(cacheSizeIndex, 1);

			super.removeViewPageAt(index);
			
			if(getViewPageCount() > 1)
			{
				destoryDividerButton(index);
			}
		}

		override public function removeAllViewPage():void
		{
			_dividerButtons = [];
			
			super.removeAllViewPage();
		}
		
		public function getDividerButtonAt(index:int):ButtonBase
		{
			return _dividerButtons[index];
		}

		public function moveDividerByDelta(dividerIndex:int, moveDelta:Number):void
		{
			if(!createCompleted || moveDelta == 0) return;

			var n:uint = _dividerButtons.length;
			if(n == 0 || dividerIndex < 0 || dividerIndex > n - 1) return;

			_changeViewPagesSizeDividerIndex = dividerIndex;
			_dividerBtnMoveDelta = moveDelta;
			
			cachePreSizeChangedChildrenSizeInfo();
			computedMinAndMaxMoveableSize();

			requestChangeViewPageSizeByMoveDelta();
		}

		private function get isHorizontal():Boolean
		{
			return this is HDividedContainer;
		}

		private function setDividerButtonDefaultSize(dividerButton:ButtonBase):void
		{
			var dividerThickness:Number = getStyle("dividerThickness") || 0;
			if(isHorizontal)
			{
				dividerButton.percentHeight = 1;
				dividerButton.width = dividerThickness;
			}
			else
			{
				dividerButton.percentWidth = 1;
				dividerButton.height = dividerThickness;
			}
		}

		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.setDisplayObjectChildIndex(this, divideIndicatorSkin, -1);
		}

		private function dividerButtonMouseRollOverHandler(event:ViburnumMouseEvent):void
		{
			if(event.isHoldTarget) return;

			if(mouseCursorDecorator != null)
			{
				_cursorDecoratorHandle = mouseCursorDecorator.setCursorHangingDrop(getStyle("dividerCursorSkin"), null, true);
			}
		}

		private function dividerButtonMouseRollOutHandler(event:ViburnumMouseEvent):void
		{
			if(event.isHoldTarget) return;

			if(mouseCursorDecorator != null)
			{
				mouseCursorDecorator.removeCursorHangingDrop(_cursorDecoratorHandle);	
				_cursorDecoratorHandle = 0;
			}
		}

		private function dividerButtonMouseDownHandler(event:MouseEvent):void
		{
			_isDividerBtnHoldedDraing = true;
			_dividerBtnStartDragMousePostion = isHorizontal ? this.mouseX : this.mouseY;
			_lastMouseDragPostion = _dividerBtnStartDragMousePostion;
			_currentMouseMoveDirection = 0;
			_changeViewPagesSizeDividerIndex = _dividerButtons.indexOf(event.currentTarget);
			_dividerBtnMoveDelta = 0;

			generateValidDynamicSkinPartNow("divideIndicatorSkin");
			
			cachePreSizeChangedChildrenSizeInfo();
			computedMinAndMaxMoveableSize();

			requestPostionDivideIndicatorSkinByMoveDelta();
		}
		
		//如果从缓存开始到，开始设置childpercentSize过程中child的includelayout minSize maxSize发生改变会导致计算有错,所以避免这样
		private function cachePreSizeChangedChildrenSizeInfo():void
		{
			_preSizeChangedChildrenSizeInfo = [];

			var child:DisplayObject;
			var n:int = myContentGroup.numChildren;
			for(var i:int = 0; i < n; i++)
			{
				child = myContentGroup.getChildAt(i);
				
				var childSizeInfo:ChildSizeInfo = new ChildSizeInfo();
				childSizeInfo.includeLayout = LayoutUtil.getDisplayObjectIncludeLayout(child);;
				childSizeInfo.minSize = isHorizontal ? 
					LayoutUtil.getDisplayObjectMinWidth(child) : 
					LayoutUtil.getDisplayObjectMinHeight(child);
				
				childSizeInfo.maxSize = isHorizontal ? 
					LayoutUtil.getDisplayObjectMaxWidth(child) : 
					LayoutUtil.getDisplayObjectMaxHeight(child);
				
				childSizeInfo.size = isHorizontal ? 
					child.width :
					child.height;
				
				childSizeInfo.percentSize = isHorizontal ? 
					LayoutUtil.getDisplayObjectPercentInWidth(child) : 
					LayoutUtil.getDisplayObjectPercentInHeight(child);

				_preSizeChangedChildrenSizeInfo.push(childSizeInfo);
			}

			_totalViewPagesPercentValue = 0;
			var m:int = getViewPageCount();
			for(var j:int = 0; j < m; j++)
			{
				var viewPage:ContainerBase = getViewPageAt(j);
				
				var viewPagePercentSize:Number = isHorizontal ? 
					LayoutUtil.getDisplayObjectPercentInWidth(viewPage) : 
					LayoutUtil.getDisplayObjectPercentInHeight(viewPage);
				
				if(!isNaN(viewPagePercentSize))
				{
					_totalViewPagesPercentValue += viewPagePercentSize;
				}
			}
		}
		
		private function getPercentChildrenLayoutSize():Number
		{
			var percentChildrenLayoutSize:Number = isHorizontal ? 
				HorizontalLayout(myContentGroup.layout).percentChildrenLayoutWSize :
				VerticalLayout(myContentGroup.layout).percentChildrenLayoutHSize;
			
			return percentChildrenLayoutSize;
		}
		
		private function computedMinAndMaxMoveableSize():void
		{
			_left2TopMoveableSizeLimitedByChildMinSize = 0;
			_left2TopMoveableSizeLimitedByChildMaxSize = 0;
			_right2BottonMoveableSizeLimitedByChildMinSize = 0;
			_right2BottonMoveableSizeLimitedByChildMaxSize = 0;

			if(_changeViewPagesSizeDividerIndex == -1) return;

			var activedDividerBtn:ButtonBase = _dividerButtons[_changeViewPagesSizeDividerIndex];
			var activedDividerBtnChildIndex:int = myContentGroup.getChildIndex(activedDividerBtn);
			
			var ltTotalSize:Number = 0;
			var ltTotalMaxSize:Number = 0;
			var ltTotalMinSize:Number = 0;

			var rtTotalSize:Number = 0;
			var rtTotalMaxSize:Number = 0;
			var rtTotalMinSize:Number = 0;
			
			var n:int = _preSizeChangedChildrenSizeInfo.length;
			for(var i:int = 0; i < n; i++)
			{
				var childSizeInfo:ChildSizeInfo = _preSizeChangedChildrenSizeInfo[i];
				
				var childIncludeLayout:Boolean = childSizeInfo.includeLayout;
				if(!childIncludeLayout) continue;
				
				var currentSize:Number = childSizeInfo.size;
				var chlildMinSize:Number = childSizeInfo.minSize;
				var chlildMaxSize:Number = childSizeInfo.maxSize;
				
				if(i < activedDividerBtnChildIndex)
				{
					ltTotalSize += currentSize;
					ltTotalMinSize += chlildMinSize;
					ltTotalMaxSize += chlildMaxSize;
				}
				else
				{
					rtTotalSize += currentSize;
					rtTotalMinSize += chlildMinSize;
					rtTotalMaxSize += chlildMaxSize;
				}
			}
			
			_left2TopMoveableSizeLimitedByChildMinSize = ltTotalSize - ltTotalMinSize;
			_left2TopMoveableSizeLimitedByChildMaxSize = ltTotalMaxSize - ltTotalSize;
			
			_right2BottonMoveableSizeLimitedByChildMinSize = rtTotalSize - rtTotalMinSize;
			_right2BottonMoveableSizeLimitedByChildMaxSize = rtTotalMaxSize - rtTotalSize;
		}
		
		private function getCurrentMoveDirection():int
		{
//			if(liveDragging)
//			{
//				return _currentMouseMoveDirection;
//			}
//			else
//			{
				if(_dividerBtnMoveDelta > 0) return 1;
				else if(_dividerBtnMoveDelta < 0) return -1;
				else return 0;
//			}
		}
		
		private function getCurrentLimitedDeltaByMinAndMaxMoveableSize():Number
		{
			var currentMoveDirection:int = getCurrentMoveDirection();
			if(currentMoveDirection == 0) return 0;
			
			var absDelta:Number = Math.abs(_dividerBtnMoveDelta);
			
			if(currentMoveDirection == -1)
			{
				absDelta = Math.min(absDelta, _left2TopMoveableSizeLimitedByChildMinSize, 
					_right2BottonMoveableSizeLimitedByChildMaxSize);
			}
			else if(currentMoveDirection == 1)
			{
				absDelta = Math.min(absDelta, _left2TopMoveableSizeLimitedByChildMaxSize, 
					_right2BottonMoveableSizeLimitedByChildMinSize);
			}
			else
			{
				return 0;
			}
			
			return _dividerBtnMoveDelta < 0 ? -absDelta : absDelta;
		}
		
		private function dividerButtonHoldMoveHandler(event:ViburnumMouseEvent):void
		{
			_dividerBtnMoveDelta = isHorizontal ? event.deltaX : event.deltaY;
			var currentMousePostion:Number = isHorizontal ? this.mouseX : this.mouseY;
			
			if(currentMousePostion < _lastMouseDragPostion)
			{
				_currentMouseMoveDirection = -1;
			}
			else if(currentMousePostion > _lastMouseDragPostion)
			{
				_currentMouseMoveDirection = 1;
			}
			else
			{
				_currentMouseMoveDirection = 0;
			}

			_lastMouseDragPostion = currentMousePostion;

			requestPostionDivideIndicatorSkinByMoveDelta();
			
//			if(liveDragging)
//			{
//				requestChangeViewPageSizeByMoveDelta();
//			}
		}

		private function dividerButtonHoldReleaseHandler(event:ViburnumMouseEvent):void
		{
			_isDividerBtnHoldedDraing = false;

			if(!event.isOnTarget && mouseCursorDecorator != null)
			{
				mouseCursorDecorator.removeCursorHangingDrop(_cursorDecoratorHandle);	
			}

			destoryValidDynamicSkinPartNow("divideIndicatorSkin");

//			if(!liveDragging)
//			{
				requestChangeViewPageSizeByMoveDelta();	
//			}
		}

		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "dividerButton_StyleName")
			{
				regenerateAllDividerButtonsStyle();
			}
			else if(styleProp == "dividerThickness")
			{
				updateLayoutGroupDividerThicknessByStyle();
			}
			else if(styleProp == "dividerCursorSkin")
			{
				if(_isDividerBtnHoldedDraing)
				{
					if(mouseCursorDecorator != null)
					{
						mouseCursorDecorator.updateCurrentCursorHangingDrop(_cursorDecoratorHandle, 
							getStyle("dividerCursorSkin"));
					}
				}
			}
		}
		
		private function regenerateAllDividerButtonsStyle():void
		{
			var n:uint = _dividerButtons.length;
			for(var i:uint = 0; i < n; i++)
			{
				var dividerButton:SimpleButton = _dividerButtons[i];
				dividerButton.styleName = getStyle("dividerButton_StyleName");
			}
		}
		
		private function updateLayoutGroupDividerThicknessByStyle():void
		{
			var n:int = _dividerButtons.length;
			for(var i:int = 0; i < n; i++)
			{
				var dividerButton:ButtonBase = _dividerButtons[i];
				setDividerButtonDefaultSize(dividerButton);
			}
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			if(_isDividerBtnHoldedDraing)
			{
				layoutDivideIndicatorSkinSize(layoutWidth, layoutHeight);
			}

			if(_requestPostionDivideIndicatorSkinByMoveDeltaFlag)
			{
				_requestPostionDivideIndicatorSkinByMoveDeltaFlag = false;
				
				if(_isDividerBtnHoldedDraing)
				{
					layoutDivideIndicatorSkinPostion();
				}
			}

			if(_changeViewPagesSizeByDividerDeltaChangedFlag)
			{
				_changeViewPagesSizeByDividerDeltaChangedFlag = false;

				changeViewPagesSizeByDividerDelta();
			}
		}
		
		private function layoutDivideIndicatorSkinSize(layoutWidth:Number, layoutHeight:Number):void
		{
			if(isHorizontal)
			{
				var divideIndicatorSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(divideIndicatorSkin);
				LayoutUtil.setDisplayObjectSize(divideIndicatorSkin, divideIndicatorSkinMW, layoutHeight);
			}
			else
			{
				var divideIndicatorSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(divideIndicatorSkin);
				LayoutUtil.setDisplayObjectSize(divideIndicatorSkin, layoutWidth, divideIndicatorSkinMH);
			}
		}
		
		private function layoutDivideIndicatorSkinPostion():void
		{
			var dividerSkinPostion:Number = 0;
			
			var currentMousePostion:Number = _dividerBtnStartDragMousePostion + 
				getCurrentLimitedDeltaByMinAndMaxMoveableSize();

			if(isHorizontal)
			{
				var divideIndicatorSkinHalfMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(divideIndicatorSkin) * 0.5;
				
				dividerSkinPostion = currentMousePostion - divideIndicatorSkinHalfMW;
				LayoutUtil.setDisplayObjectPosition(divideIndicatorSkin, dividerSkinPostion, 0);
			}
			else
			{
				var divideIndicatorSkinHalfMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(divideIndicatorSkin) * 0.5;
				
				dividerSkinPostion = currentMousePostion - divideIndicatorSkinHalfMH;
				LayoutUtil.setDisplayObjectPosition(divideIndicatorSkin, 0, dividerSkinPostion);
			}
		}
		
		private function increase2DecreateChildSizeByValue(absvalue:Number, 
														   currentChildIndex:int, 
														   isIncreasedChildIndex:Boolean, 
														   isMoveToward:Boolean):void
		{
			var n:int = _preSizeChangedChildrenSizeInfo.length;
			if(n == 0) return;
			
			if(absvalue == 0) return;

			var childIndex:int = -1;

			if(isIncreasedChildIndex)
			{
				childIndex = currentChildIndex + 1;
				if(childIndex > n - 1) return;
			}
			else
			{
				childIndex = currentChildIndex - 1;
				if(childIndex < 0) return;
			}
			
			var child:DisplayObject = myContentGroup.getChildAt(childIndex);
			
			var childSizeInfo:ChildSizeInfo = _preSizeChangedChildrenSizeInfo[childIndex];
			var childSize:Number = childSizeInfo.size;
			var childPercentSize:Number = childSizeInfo.percentSize;
			
			var isSizeableChild:Boolean = !isNaN(childPercentSize);
			if(isSizeableChild)
			{
				if(isMoveToward)
				{
					//这里只可能>=
					var childSizea2MinSizeDistance:Number = childSize - childSizeInfo.minSize;
					if(childSizea2MinSizeDistance < absvalue)
					{
						childSizeInfo.size = childSizeInfo.minSize;
						setChildPercentSizeByCurrentSize(childSizeInfo.size, child);

						increase2DecreateChildSizeByValue(absvalue - childSizea2MinSizeDistance, 
							childIndex, isIncreasedChildIndex, isMoveToward);
					}
					else//>=
					{
						childSizeInfo.size -= absvalue;
						setChildPercentSizeByCurrentSize(childSizeInfo.size, child);
					}
				}
				else
				{
					//这里只可能<=
					var childSize2MaxSizeDistance:Number = childSizeInfo.maxSize - childSize;
					if(childSize2MaxSizeDistance < absvalue)
					{
						childSizeInfo.size = childSizeInfo.maxSize;
						setChildPercentSizeByCurrentSize(childSizeInfo.size, child);
						
						increase2DecreateChildSizeByValue(absvalue - childSize2MaxSizeDistance, 
							childIndex, isIncreasedChildIndex, isMoveToward);
					}
					else//>=
					{
						childSizeInfo.size += absvalue;
						setChildPercentSizeByCurrentSize(childSizeInfo.size, child);
					}
				}
			}
			else
			{
				increase2DecreateChildSizeByValue(absvalue, childIndex, isIncreasedChildIndex, isMoveToward);
			}
		}
		
		private function setChildPercentSizeByCurrentSize(childSize:Number, child:DisplayObject):void
		{
			if(child is ILayoutElement)
			{
				var percentChildrenLayoutSize:Number = getPercentChildrenLayoutSize();
				var childPercent:Number = childSize * _totalViewPagesPercentValue / percentChildrenLayoutSize;
				if(isHorizontal)
				{
					ILayoutElement(child).percentWidth = childPercent;	
				}
				else
				{
					ILayoutElement(child).percentHeight = childPercent;
				}
			}
		}

		private function changeViewPagesSizeByDividerDelta():void
		{
			var dividerBtn:ButtonBase = _dividerButtons[_changeViewPagesSizeDividerIndex];
			var limitedDelta:Number = getCurrentLimitedDeltaByMinAndMaxMoveableSize();
			var currentMoveDirection:int = getCurrentMoveDirection();
			
			if(currentMoveDirection == 0 || dividerBtn == null || limitedDelta == 0) return;

			var dividerBtnChildIndex:int = myContentGroup.getChildIndex(dividerBtn);

			var isMoveTowardIncreasedChildIndex:Boolean = currentMoveDirection == 1;
			var isMoveUnTowardIncreasedChildIndex:Boolean = !isMoveTowardIncreasedChildIndex;
			
			var asblimitedDelta:Number = Math.abs(limitedDelta);

			increase2DecreateChildSizeByValue(asblimitedDelta, dividerBtnChildIndex, isMoveTowardIncreasedChildIndex, true);
			increase2DecreateChildSizeByValue(asblimitedDelta, dividerBtnChildIndex, isMoveUnTowardIncreasedChildIndex, false);
		
			myContentGroup.invalidateDisplayList();
		}
		
		private function getNextMoveableSizeChildByCurrentChildSizeInfo(currentChildIndex:int, 
																		isIncreasedChildIndex:Boolean, 
																		isMoveToward:Boolean):ILayoutElement
		{
			var n:int = _preSizeChangedChildrenSizeInfo.length;
			if(n == 0) return null;

			var childIndex:int = -1;

			if(isIncreasedChildIndex)
			{
				childIndex = currentChildIndex + 1;
				if(childIndex > n - 1) return null;
			}
			else
			{
				childIndex = currentChildIndex - 1;
				if(childIndex < 0) return null;
			}
			
			var child:DisplayObject = myContentGroup.getChildAt(childIndex);
			
			var childSizeInfo:ChildSizeInfo = _preSizeChangedChildrenSizeInfo[childIndex];
			var childSize:Number = childSizeInfo.size;
			var childPercentSize:Number = childSizeInfo.percentSize;
			
			var isSizeableChild:Boolean = !isNaN(childPercentSize);
			
			if(isMoveToward)
			{
				if(isSizeableChild && childSize > childSizeInfo.minSize)
				{
					return ILayoutElement(child);
				}
			}
			else
			{
				if(isSizeableChild && childSize < childSizeInfo.maxSize)
				{
					return ILayoutElement(child);
				}
			}

			return null;
		}
    }
}

class ChildSizeInfo
{
	public var minSize:Number;
	public var maxSize:Number;
	public var includeLayout:Boolean;
	
	public var size:Number;
	public var percentSize:Number;
}