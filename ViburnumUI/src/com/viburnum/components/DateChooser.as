package com.viburnum.components
{
	import com.viburnum.components.baseClasses.PanelBase;
	import com.viburnum.components.supportClasses.DataChooserTitleBar;
	import com.viburnum.events.DateChooserEvent;
	import com.alex.utils.DateUtil;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	[Event(name="selectedDate", type="com.viburnum.events.DateChooserEvent")]
	
	[Style(name="prevMonthButtonSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_upSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_overSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_downSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_disabledSkin", type="Class")]
	
	[Style(name="prevYearButtonSkin", type="Class")]
	[Style(name="prevYearButtonSkin_upSkin", type="Class")]
	[Style(name="prevYearButtonSkin_overSkin", type="Class")]
	[Style(name="prevYearButtonSkin_downSkin", type="Class")]
	[Style(name="prevYearButtonSkin_disabledSkin", type="Class")]
	
	[Style(name="nextYearButtonSkin", type="Class")]
	[Style(name="nextYearButtonSkin_upSkin", type="Class")]
	[Style(name="nextYearButtonSkin_overSkin", type="Class")]
	[Style(name="nextYearButtonSkin_downSkin", type="Class")]
	[Style(name="nextYearButtonSkin_disabledSkin", type="Class")]

	[Style(name="yearLabelStyleName", type="String")]
	[Style(name="monthLabelStyleName", type="String")]
	
	[Style(name="nextMonthButtonSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_upSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_overSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_downSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_disabledSkin", type="Class")]
	
	[Style(name="repeatInterval", type="Number", format="Time", minValue="0.0")]

	[Style(name="dateItemRenderStyleName", type="String")]
	[Style(name="dayLabelStyleName", type="String")]
	[Style(name="dateLabelStyleName", type="String")]
	
    public class DateChooser extends PanelBase implements IFocusManagerComponent
    {
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"prevMonthButtonSkin", type:"Class"},
				{name:"prevMonthButtonSkin_upSkin", type:"Class"},
				{name:"prevMonthButtonSkin_overSkin", type:"Class"},
				{name:"prevMonthButtonSkin_downSkin", type:"Class"},
				{name:"prevMonthButtonSkin_disabledSkin", type:"Class"},
				
				{name:"prevYearButtonSkin", type:"Class"},
				{name:"prevYearButtonSkin_upSkin", type:"Class"},
				{name:"prevYearButtonSkin_overSkin", type:"Class"},
				{name:"prevYearButtonSkin_downSkin", type:"Class"},
				{name:"prevYearButtonSkin_disabledSkin", type:"Class"},
				
				{name:"nextYearButtonSkin", type:"Class"},
				{name:"nextYearButtonSkin_upSkin", type:"Class"},
				{name:"nextYearButtonSkin_overSkin", type:"Class"},
				{name:"nextYearButtonSkin_downSkin", type:"Class"},
				{name:"nextYearButtonSkin_disabledSkin", type:"Class"},
				
				{name:"yearLabelStyleName", type:"String"},
				{name:"monthLabelStyleName", type:"String"},
				
				{name:"nextMonthButtonSkin", type:"Class"},
				{name:"nextMonthButtonSkin_upSkin", type:"Class"},
				{name:"nextMonthButtonSkin_overSkin", type:"Class"},
				{name:"nextMonthButtonSkin_downSkin", type:"Class"},
				{name:"nextMonthButtonSkin_disabledSkin", type:"Class"},
				
				{name:"repeatInterval", type:"Number", format:"Time", minValue:"0.0"},
				
				{name:"dateItemRenderStyleName", type:"String"},
				{name:"dayLabelStyleName", type:"String"},
				{name:"dateLabelStyleName", type:"String"},
			]
		}
		
		protected var dataChooserContentForm:DataChooserContentForm;

		private var _minYear:int = 1900;
		private var _maxYear:int = 2100;
		
		private var _selectedDate:Date;
		private var _selectedDateChangedFlag:Boolean = false;
		
		private var _displayDate:Date;
		
		private var _dayNames:Array;
		private var _dayNamesChangedFlag:Boolean = false;

		private var _monthNames:Array;
		private var _monthSymbol:String;
		private var _monthTextChangedFlag:Boolean = false;

		private var _yearSymbol:String;
		private var _yearSymbolChangedFlag:Boolean = false;
		
        public function DateChooser()
        {
            super();

			allowDragWhenPopUp = false;
			
			_selectedDate = new Date();
			_displayDate = new Date();

			tabChildren = false;

			myTitleBar = new DataChooserTitleBar();
        }
		
		public function get selectedDate():Date
		{
			return _selectedDate;
		}
		
		public function set selectedDate(value:Date):void
		{
			_selectedDate = value;

			if(_selectedDate != null)
			{
				if(hasEventListener(DateChooserEvent.DATE_SELECTED))
				{
					var dateChooserEvent:DateChooserEvent = new DateChooserEvent(DateChooserEvent.DATE_SELECTED);
					dateChooserEvent.year = _selectedDate.fullYear;
					dateChooserEvent.month = _selectedDate.month;
					dateChooserEvent.date = _selectedDate.date;
					dispatchEvent(dateChooserEvent);
				}
			}
			
			_selectedDateChangedFlag = true;
			invalidateProperties();
		}
		
		public function get maxYear():int
		{
			return _maxYear;
		}

		[Inspectable(type="Number")]
		public function set maxYear(value:int):void
		{
			if(_maxYear != value)
			{
				_maxYear = value;	
			}
		}
		
		public function get minYear():int
		{
			return _minYear;
		}
		
		[Inspectable(type="Number")]
		public function set minYear(value:int):void
		{
			if(_minYear != value)
			{
				_minYear = value;
			}
		}

		public function get dayNames():Array
		{
			return _dayNames != null ?
				_dayNames :
				langManager.getStringArray("DateChooser", "dayNames");
		}
		
		[Inspectable(type="Array")]
		public function set dayNames(value:Array):void
		{
			_dayNames = value;
			
			_dayNamesChangedFlag = true;
			invalidateProperties();
		}
		
		public function get monthNames():Array
		{
			return _monthNames != null ?
				_monthNames :
				langManager.getStringArray("DateChooser", "monthNames");
		}
		
		[Inspectable(type="Array")]
		public function set monthNames(value:Array):void
		{
			_monthNames = value;
			
			_monthTextChangedFlag = true;
			invalidateProperties();
		}
		
		public function get monthSymbol():String
		{
			return _monthSymbol != null ?
				_monthSymbol :
				langManager.getString("DateChooser", "monthSymbol");
		}
		
		[Inspectable(type="String")]
		public function set monthSymbol(value:String):void
		{
			if(monthSymbol != value)
			{
				_monthSymbol = value;
				
				_monthTextChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function get yearSymbol():String
		{
			return _yearSymbol != null ?
				_yearSymbol :
				langManager.getString("DateChooser", "yearSymbol");
		}
		
		[Inspectable(type="String")]
		public function set yearSymbol(value:String):void
		{
			if(yearSymbol != value)
			{
				_yearSymbol = value;
				
				_yearSymbolChangedFlag = true;
				invalidateProperties();
			}
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "prevMonthButtonSkin" || styleProp == "prevMonthButtonSkin_upSkin" || 
				styleProp == "prevMonthButtonSkin_overSkin" || styleProp == "prevMonthButtonSkin_downSkin" || 
				styleProp == "prevMonthButtonSkin_disabledSkin" ||
				styleProp == "prevYearButtonSkin" || styleProp == "prevYearButtonSkin_upSkin" || 
				styleProp == "prevYearButtonSkin_overSkin" || styleProp == "prevYearButtonSkin_downSkin" || 
				styleProp == "prevYearButtonSkin_disabledSkin" ||
				styleProp == "nextYearButtonSkin" || styleProp == "nextYearButtonSkin_upSkin" || 
				styleProp == "nextYearButtonSkin_overSkin" || styleProp == "nextYearButtonSkin_downSkin" || 
				styleProp == "nextYearButtonSkin_disabledSkin" ||
				styleProp == "yearLabelStyleName" || styleProp == "monthLabelStyleName" ||
				styleProp == "nextMonthButtonSkin" || styleProp == "nextMonthButtonSkin_upSkin" || 
				styleProp == "nextMonthButtonSkin_overSkin" || styleProp == "nextMonthButtonSkin_downSkin" || 
				styleProp == "nextMonthButtonSkin_disabledSkin" ||
				styleProp == "repeatInterval")
			{
				myTitleBar.setStyle(styleProp, getStyle(styleProp));
			}
			else if(styleProp == "dateItemRenderStyleName")
			{
				dataChooserContentForm.itemRenderStyleName = getStyle(styleProp);
			}
			else if(styleProp == "dayLabelStyleName")
			{
				dataChooserContentForm.dayLabelStyleName = getStyle(styleProp);
			}
			else if(styleProp == "dateLabelStyleName")
			{
				dataChooserContentForm.dateLabelStyleName = getStyle(styleProp);
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_selectedDateChangedFlag)
			{
				_selectedDateChangedFlag = false;
				
				selectedDateChanged();
			}
		}
		
		private function selectedDateChanged():void
		{
			if(_selectedDate == null)
			{
				dataChooserContentForm.selectedItemIndex = -1;
			}
			else
			{
				if(_selectedDate.fullYear == _displayDate.fullYear && _selectedDate.month == _displayDate.month)
				{
					//0 - 6
					var dateNum:uint = DateUtil.getMaxDateByYearMoth(_displayDate.fullYear, _displayDate.month);
					var firstDateDay:uint = DateUtil.getFirstDateDayByYearMoth(_displayDate.fullYear, _displayDate.month);
					
					var selectedIndex:uint = firstDateDay + _selectedDate.date - 1;

					dataChooserContentForm.selectedItemIndex = selectedIndex;
				}
				else
				{
					dataChooserContentForm.selectedItemIndex = -1;
				}
			}
		}
		
		private function showDateByCurrentDate():void
		{
			dataChooserTitleBar.yearText = getCurrentDateYearString();
			dataChooserTitleBar.monthText = getCurrentDateMonthString();
			
			//0 - 6
			var dateNum:uint = DateUtil.getMaxDateByYearMoth(_displayDate.fullYear, _displayDate.month);
			var firstDateDay:uint = DateUtil.getFirstDateDayByYearMoth(_displayDate.fullYear, _displayDate.month);
			
			var minDateShowIndex:uint = firstDateDay;
			var maxDateShowIndex:uint = minDateShowIndex + dateNum - 1;
			dataChooserContentForm.showDates(minDateShowIndex, maxDateShowIndex);
			
			selectedDateChanged();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			dataChooserContentForm = new DataChooserContentForm();
			dataChooserContentForm.addEventListener(DateChooserEvent.DATE_SELECTED, dataChooserContentFormSelectedDateHandler);
			dataChooserContentForm.owner = this;
			dataChooserContentForm.percentWidth = 1;
			dataChooserContentForm.percentHeight = 1;
			dataChooserContentForm.dayNames = dayNames;
			myContentGroup.addChild(dataChooserContentForm);
			
			myTitleBar.addEventListener(DateChooserEvent.PREV_MONTH_BUTTON_CLICK, prevMonthButtonClickHandler);
			myTitleBar.addEventListener(DateChooserEvent.NEXT_MONTH_BUTTON_CLICK, nextMonthButtonClickHandler);
			
			myTitleBar.addEventListener(DateChooserEvent.PREV_YEAR_BUTTON_CLICK, prevYearButtonClickHandler);
			myTitleBar.addEventListener(DateChooserEvent.NEXT_YEAR_BUTTON_CLICK, nextYearButtonClickHandler);
		}
		
		override protected function onInitializeComplete():void
		{
			super.onInitializeComplete();
			
			showDateByCurrentDate();
		}
		
		private function showPreMonth():void
		{
			if(_displayDate.fullYear - 1 < _minYear && _displayDate.month == 0) return;
			
			_displayDate.month -= 1;
			
			showDateByCurrentDate();
		}
		
		private function showNextMonth():void
		{
			if(_displayDate.fullYear + 1 > _maxYear && _displayDate.month == 11) return;
			
			_displayDate.month += 1;
			showDateByCurrentDate();
		}
		
		private function showPreYear():void
		{
			if(_displayDate.fullYear - 1 < _minYear) return;
			
			_displayDate.fullYear -= 1;
			showDateByCurrentDate();
		}
		
		private function showNextYear():void
		{
			if(_displayDate.fullYear + 1 > _maxYear) return;
			
			_displayDate.fullYear += 1;
			showDateByCurrentDate();
		}
		
		private function getCurrentDateMonthString():String
		{
			var s:String = monthNames[_displayDate.month] + monthSymbol;
			return s;
		}
		
		private function getCurrentDateYearString():String
		{
			var s:String = _displayDate.getFullYear() + yearSymbol;
			return s;
		}
		
		private function get dataChooserTitleBar():DataChooserTitleBar
		{
			return DataChooserTitleBar(myTitleBar);
		}
		
		private function dataChooserContentFormSelectedDateHandler(event:DateChooserEvent):void
		{
			var date:uint = event.date;
			
			_displayDate.date = date;
			
			var choosedDate:Date = DateUtil.cloneDate(_displayDate);
			selectedDate = choosedDate;
		}
		
		//event handler
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
				case Keyboard.PAGE_UP:
					showPreMonth();
					break;
				
				case Keyboard.RIGHT:
				case Keyboard.PAGE_DOWN:
					showNextMonth();
					break; 
				
				case Keyboard.UP:
					showPreYear();
					break;
				
				case Keyboard.DOWN:
					showNextYear();
					break;
			}
		}
		
		private function prevMonthButtonClickHandler(event:DateChooserEvent):void
		{
			showPreMonth();
		}
		
		private function nextMonthButtonClickHandler(event:DateChooserEvent):void
		{
			showNextMonth();
		}
		
		private function prevYearButtonClickHandler(event:DateChooserEvent):void
		{
			showPreYear();
		}
		
		private function nextYearButtonClickHandler(event:DateChooserEvent):void
		{
			showNextYear();
		}
    }
}

import com.viburnum.components.Label;
import com.viburnum.components.TileGroup;
import com.viburnum.components.supportClasses.LabelItemRender;
import com.viburnum.events.DateChooserEvent;
import com.viburnum.layouts.TileLayout;

import flash.events.MouseEvent;

internal class DataChooserContentForm extends TileGroup
{
	private static const COLUMN_COUNT:uint = 7;
	private static const ROW_COUNT:uint = 6;
	
	private var _dayLabels:Array = [];//Label
	private var _dayItemRenders:Array = [];//DefaultLabelItemRender

	private var _dayNames:Array;
	private var _dayNamesChangedFlag:Boolean = false;

	private var _minDateShowIndex:uint = 0;
	private var _maxDateShowIndex:uint = 0;
	private var _requestShowDatesFlag:Boolean = false;
	
	private var _itemRenderStyleName:Object;
	private var _itemRenderStyleNameChangedFlag:Boolean = false;
	
	private var _dayLabelStyleName:Object;
	private var _dayLabelStyleNameChangedFlag:Boolean = false;
	
	private var _dateLabelStyleName:Object;
	private var _dateLabelStyleNameChangedFlag:Boolean = false;
	
	private var _selectedItemIndex:int = -1;
	private var _selectedItemIndexChangedFlag:Boolean = false;
	
	private var _lastSelectedDateItemRender:LabelItemRender;

	public function DataChooserContentForm()
	{
		super();
		
		TileLayout(layout).columnCount = COLUMN_COUNT;
		TileLayout(layout).rowCount = ROW_COUNT;
	}
	
	public function get selectedItemIndex():int
	{
		return _selectedItemIndex;
	}

	public function set selectedItemIndex(value:int):void
	{
		if(_selectedItemIndex != value)
		{
			_selectedItemIndex = value;
			
			_selectedItemIndexChangedFlag = true;
			invalidateProperties();
		}
	}
	
	public function showDates(minDateShowIndex:uint, maxDateShowIndex:uint):void
	{
		_minDateShowIndex = minDateShowIndex;
		_maxDateShowIndex = maxDateShowIndex;

		_requestShowDatesFlag = true;
		invalidateProperties()
	}
	
	public function get itemRenderStyleName():Object
	{
		return _itemRenderStyleName;
	}
	
	public function set itemRenderStyleName(value:Object):void
	{
		if(_itemRenderStyleName != value)
		{
			_itemRenderStyleName = value;
			
			_itemRenderStyleNameChangedFlag = true;
			invalidateProperties();
		}
	}

	public function get dayLabelStyleName():Object
	{
		return _dayLabelStyleName;
	}
	
	public function set dayLabelStyleName(value:Object):void
	{
		if(_dayLabelStyleName != value)
		{
			_dayLabelStyleName = value;

			_dayLabelStyleNameChangedFlag = true;
			invalidateProperties();
		}
	}
	
	public function get dateLabelStyleName():Object
	{
		return _dateLabelStyleName;
	}
	
	public function set dateLabelStyleName(value:Object):void
	{
		if(_dateLabelStyleName != value)
		{
			_dateLabelStyleName = value;
			
			_dateLabelStyleNameChangedFlag = true;
			invalidateProperties();
		}
	}

	public function set dayNames(value:Array):void
	{
		_dayNames = value;

		_dayNamesChangedFlag = true;
		invalidateProperties();
	}

	override protected function onInitialize():void
	{
		super.onInitialize();
		
		var n:uint = ROW_COUNT * COLUMN_COUNT;
		for(var i:uint = 0; i < n; i++)
		{
			if(i < COLUMN_COUNT)
			{
				var dayLabel:Label = new Label();
				dayLabel.percentWidth = 1;
				addChild(dayLabel);

				_dayLabels.push(dayLabel);
			}
			else
			{
				var dayItemRender:LabelItemRender = new LabelItemRender();
				dayItemRender.percentWidth = 1;
				dayItemRender.percentHeight = 1;
				dayItemRender.visible = false;
				dayItemRender.addEventListener(MouseEvent.CLICK, dayItemRenderClickHandler);
				addChild(dayItemRender);

				_dayItemRenders.push(dayItemRender);
			}
		}
	}

	override protected function onValidateProperties():void
	{
		super.onValidateProperties();
		
		if(_dayNamesChangedFlag)
		{
			_dayNamesChangedFlag = false;
			
			dayNameChanged();
		}
		
		if(_requestShowDatesFlag)
		{
			_requestShowDatesFlag = false;
			
			updateDayItemRenders();
		}
		
		if(_itemRenderStyleNameChangedFlag)
		{
			_itemRenderStyleNameChangedFlag = false;
			
			updateDayItemRendersStyleName();
		}
		
		if(_dayLabelStyleNameChangedFlag)
		{
			_dayLabelStyleNameChangedFlag = false;
			
			updateDayLabelsStyleName();
		}
		
		if(_dateLabelStyleNameChangedFlag)
		{
			_dateLabelStyleNameChangedFlag = false;
			
			updateDateLabelsStyleName();
		}
		
		if(_selectedItemIndexChangedFlag)
		{
			_selectedItemIndexChangedFlag = false;
			
			selectedDateItemRender();
		}
	}
	
	private function updateDayItemRendersStyleName():void
	{
		var n:uint = _dayItemRenders.length;
		for(var i:uint = 0; i < n; i++)
		{
			var dayItemRender:LabelItemRender =  LabelItemRender(_dayItemRenders[i]);
			dayItemRender.styleName = _itemRenderStyleName;
		}
	}
	
	private function updateDayLabelsStyleName():void
	{
		var n:uint = _dayLabels.length;
		for(var i:uint = 0; i < n; i++)
		{
			var dayLabel:Label = Label(_dayLabels[i]);
			dayLabel.styleName = _dayLabelStyleName;
		}
	}
	
	private function updateDateLabelsStyleName():void
	{
		var n:uint = _dayItemRenders.length;
		for(var i:uint = 0; i < n; i++)
		{
			var dayItemRender:LabelItemRender =  LabelItemRender(_dayItemRenders[i]);
			dayItemRender.setStyle("labelStyleName", _dateLabelStyleName);
		}
	}
	
	private function updateDayItemRenders():void
	{
		var n:uint = _dayItemRenders.length;
		for(var i:uint = 0; i < n; i++)
		{
			var dateItemRender:LabelItemRender =  LabelItemRender(_dayItemRenders[i]);
			var isShowDayItemRender:Boolean = i >= _minDateShowIndex && i <= _maxDateShowIndex;
			dateItemRender.visible = isShowDayItemRender;
			if(isShowDayItemRender)
			{
				dateItemRender.label = (i - _minDateShowIndex + 1).toString();
			}
		}
	}

	private function selectedDateItemRender():void
	{
		if(_lastSelectedDateItemRender != null)
		{
			_lastSelectedDateItemRender.selected = false;
			_lastSelectedDateItemRender = null;
		}
		
		if(_selectedItemIndex >= _minDateShowIndex && _selectedItemIndex <= _maxDateShowIndex)
		{
			_lastSelectedDateItemRender = _dayItemRenders[_selectedItemIndex];
		}
		
		if(_lastSelectedDateItemRender != null)
		{
			_lastSelectedDateItemRender.selected = true;
		}
	}

	private function dayNameChanged():void
	{
		var n:int = _dayLabels.length;
		for(var i:int = 0; i < n; i++)
		{
			var label:Label = _dayLabels[i];
			var labelText:String = _dayNames[i];
			
			label.text = labelText;
		}
	}
	
	private function dayItemRenderClickHandler(event:MouseEvent):void
	{
		var itemIndex:int = _dayItemRenders.indexOf(event.currentTarget);
		var selectedDate:uint = itemIndex - _minDateShowIndex + 1;
		
		if(hasEventListener(DateChooserEvent.DATE_SELECTED))
		{
			var dateChooserEvent:DateChooserEvent = new DateChooserEvent(DateChooserEvent.DATE_SELECTED);
			dateChooserEvent.date = selectedDate;
			dispatchEvent(dateChooserEvent);
		}
	}
}