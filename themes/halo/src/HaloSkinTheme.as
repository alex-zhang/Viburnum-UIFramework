package
{
	import com.viburnum.skins.DefaultBackgroundSkin;
	import com.viburnum.skins.DefaultBorderSkin;
	import com.viburnum.skins.EmptySkin;
	import com.viburnum.skins.HRuleSkin;
	import com.viburnum.skins.SkinsProgrammaticSkin;
	import com.viburnum.skins.TreeRelationWireSkin;
	import com.viburnum.skins.VRuleSkin;
	import com.viburnum.style.IStyleManager;
	import com.viburnum.utils.ClassFactory;
	
	public class HaloSkinTheme
	{
		public static var assetName:String = "halo";
		public static var assetType:String = "Theme";
		
		//0:Application 1:styleManager
		public static function create(...parameters):Object
		{
			var css:Object = {};
			
			//System parts
			/******************************************************************/
			
			//common
			//----------------------------------------------------------------->
			//-----------------------------------------------------------------|
			
			//global
			//----------------------------------------------------------------->
			css.global = 
			{
				modalSkin : global_modalSkin
			}
			//-----------------------------------------------------------------|
			
			/**AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA**/
			
			//Application
			//----------------------------------------------------------------->
			css.Application =
			{
				backgroundSkin_backgroundColor : 0x849AA5,
				color : 0x000000,
				fontSize : 12
			}
			//-----------------------------------------------------------------|
			
			//Accordion
			//----------------------------------------------------------------->
			css.Accordion =
			{
				accordionTitleBar_styleName : "accordionTitleBar_styleName"
			}
			
			css.accordionTitleBar_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : VAccordionTitleBar_upSkin,
				backgroundSkin_overSkin : VAccordionTitleBar_overSkin,
				backgroundSkin_downSkin : VAccordionTitleBar_downSkin,
				backgroundSkin_disabledSkin : VAccordionTitleBar_disabledSkin,
				
				backgroundSkin_selected_upSkin : VAccordionTitleBar_overSkin,
				backgroundSkin_selected_overSkin : VAccordionTitleBar_overSkin,
				backgroundSkin_selected_downSkin : VAccordionTitleBar_downSkin,
				backgroundSkin_selected_disabledSkin : VAccordionTitleBar_disabledSkin
			}
			//-----------------------------------------------------------------|
			
			//Alert
			//----------------------------------------------------------------->
			css.Alert =
			{
				borderSkin : new ClassFactory(DefaultBorderSkin),
				titleBackgroundSkin : new ClassFactory(TitleBar_backgroundSkin, {width: 50})
			}
			//-----------------------------------------------------------------|
			
			/**BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB**/
			
			//Button
			//----------------------------------------------------------------->
			css.Button =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : Button_upSkin,
				backgroundSkin_overSkin : Button_overSkin,
				backgroundSkin_downSkin : Button_downSkin,
				backgroundSkin_disabledSkin : Button_disabledSkin,
				
				paddingLeft : 6,
				paddingRight : 6,
				paddingTop : 2,
				paddingBottom : 2,
				
				gap : 4
			}
			//-----------------------------------------------------------------|
			
			/**CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC**/
			
			//CheckBox
			//----------------------------------------------------------------->
			css.CheckBox =
			{
				backgroundSkin : null,
				iconSkin : SkinsProgrammaticSkin,
				iconSkin_upSkin : CheckBox_upIcon,
				iconSkin_overSkin : CheckBox_overIcon,
				iconSkin_downSkin : CheckBox_downIcon,
				iconSkin_disabledSkin : CheckBox_disabledIcon,
				iconSkin_selected_upSkin : CheckBox_selectedUpIcon,
				iconSkin_selected_overSkin : CheckBox_selectedOverIcon,
				iconSkin_selected_downSkin : CheckBox_selectedDownIcon,
				iconSkin_selected_disabledSkin : CheckBox_selectedDisabledIcon
			}
			//-----------------------------------------------------------------|
			
			//ComboBox
			//----------------------------------------------------------------->
			css.ComboBox =
			{
				openButtonStyleName : "ComboBox_openButtonStyleName",
				textInputStyleName : "ComboBox_textInputStyleName"
			}
			
			css.ComboBox_openButtonStyleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : ComboBox_openButton_upSkin,
				backgroundSkin_overSkin : ComboBox_openButton_overSkin,
				backgroundSkin_downSkin : ComboBox_openButton_downSkin,
				backgroundSkin_disabledSkin : ComboBox_openButton_disabledSkin
			}
			//-----------------------------------------------------------------|
			
			/**DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD**/
			
			//DateChooser
			//----------------------------------------------------------------->
			css.DateChooser =
			{
				titleBackgroundSkin : TitleBar_backgroundSkin,
				
				prevMonthButtonSkin : SkinsProgrammaticSkin,
				prevMonthButtonSkin_upSkin : DateChooser_prevMonthUpSkin,
				prevMonthButtonSkin_overSkin : DateChooser_prevMonthOverSkin,
				prevMonthButtonSkin_downSkin : DateChooser_prevMonthDownSkin,
				prevMonthButtonSkin_disabledSkin : DateChooser_prevMonthDisabledSkin,
				
				prevYearButtonSkin : SkinsProgrammaticSkin,
				prevYearButtonSkin_upSkin : DateChooser_prevYearUpSkin,
				prevYearButtonSkin_overSkin : DateChooser_prevYearOverSkin,
				prevYearButtonSkin_downSkin : DateChooser_prevYearDownSkin,
				prevYearButtonSkin_disabledSkin : DateChooser_prevYearDisabledSkin,
				
				nextYearButtonSkin : SkinsProgrammaticSkin,
				nextYearButtonSkin_upSkin : DateChooser_nextYearUpSkin,
				nextYearButtonSkin_overSkin : DateChooser_nextYearOverSkin,
				nextYearButtonSkin_downSkin : DateChooser_nextYearDownSkin,
				nextYearButtonSkin_disabledSkin : DateChooser_nextYearDisabledSkin,
				
				nextMonthButtonSkin : SkinsProgrammaticSkin,
				nextMonthButtonSkin_upSkin : DateChooser_nextMonthUpSkin,
				nextMonthButtonSkin_overSkin : DateChooser_nextMonthOverSkin,
				nextMonthButtonSkin_downSkin : DateChooser_nextMonthDownSkin,
				nextMonthButtonSkin_disabledSkin : DateChooser_nextMonthDisabledSkin,
				
				repeatInterval : 180,
				
				textAlign : "center",
				
				dayLabelStyleName : "DateChooser_dayLabelStyleName",
				dateLabelStyleName : "DateChooser_dateLabelStyleName"
			}
			
			//---->
			
			css.DateChooser_dayLabelStyleName =
			{
				fontWeight : "bold"
			}
			
			//---->
			
			css.DateChooser_dateLabelStyleName =
			{
				textDecoration : "underline"
			}
			//-----------------------------------------------------------------|
			
			//DropDownList
			//----------------------------------------------------------------->
			css.DropDownList =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : DropDownList_upSkin,
				backgroundSkin_overSkin : DropDownList_overSkin,
				backgroundSkin_downSkin : DropDownList_downSkin,
				backgroundSkin_disabledSkin : DropDownList_disabledSkin,
				
				paddingLeft : 4,
				paddingRight : 25,
				paddingTop : 2,
				paddingBottom : 2
			}
			//-----------------------------------------------------------------|
			
			//DateField
			//----------------------------------------------------------------->
			css.DateField =
			{ 
				dateFieldIcon : DateField_IconSkin,
				
				gap : 2
			}
			//-----------------------------------------------------------------|
			
			/**EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE**/
			
			/**FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF**/
			
			/**GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG**/
			
			/**HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH**/
			
			//HScrollBar
			//----------------------------------------------------------------->
			css.HScrollBar =
			{
				trackButton_styleName : "HScrollBar_trackButton_styleName",
				thumbButton_styleName : "HScrollBar_thumbButton_styleName",
				decrementButton_styleName : "HScrollBar_decrementButton_styleName",
				incrementButton_styleName : "HScrollBar_incrementButton_styleName",
				autoThumbVisibility : true
			}
			
			//---->
			
			css.HScrollBar_thumbButton_styleName =
			{
				paddingLeft : 2,
				paddingRight : 2,
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : HScrollThumb_upSkin,
				backgroundSkin_overSkin : HScrollThumb_overSkin,
				backgroundSkin_downSkin : HScrollThumb_downSkin,
				backgroundSkin_disabledSkin : HScrollThumb_upSkin,
				iconSkin : HScrollBar_thumbIcon
			}
			
			//---->
			
			css.HScrollBar_trackButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : HScrollTrack_Skin,
				backgroundSkin_overSkin : HScrollTrack_Skin,
				backgroundSkin_downSkin : HScrollTrack_Skin,
				backgroundSkin_disabledSkin : HScrollTrack_DisabledSkin
			}
			
			//---->
			
			css.HScrollBar_decrementButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : HScrollArrowUp_upSkin,
				backgroundSkin_overSkin : HScrollArrowUp_overSkin,
				backgroundSkin_downSkin : HScrollArrowUp_downSkin,
				backgroundSkin_disabledSkin : HScrollArrowUp_disabledSkin
			}
			
			//---->
			
			css.HScrollBar_incrementButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : HScrollArrowDown_upSkin,
				backgroundSkin_overSkin : HScrollArrowDown_overSkin,
				backgroundSkin_downSkin : HScrollArrowDown_downSkin,
				backgroundSkin_disabledSkin : HScrollArrowDown_disabledSkin
			}
			//-----------------------------------------------------------------|
			
			//HRule
			//----------------------------------------------------------------->
			css.HRule =
			{
				strokeSkin : HRuleSkin,
				strokeSkin_shadowColor : 0xC4CCCC,
				strokeSkin_strokeColor : 0xEEEEEE,
				strokeSkin_strokeWidth : 2
			}
			//-----------------------------------------------------------------|
			
			//HSlider
			//----------------------------------------------------------------->
			css.HSlider =
			{
				trackButton_styleName : "HSlider_trackButton_styleName",
				thumbButton_styleName : "HSlider_thumbButton_styleName",
				dataTip_styleName : "ToolTip",
				hightlightSkin : HSliderHighlight_Skin,
				slideDuration : 100,
				dataTipSideoffset : -5
			}
			
			//---->
			
			css.HSlider_trackButton_styleName =
			{
				backgroundSkin : HSliderTrack_Skin
			}
			
			//----->
			
			css.HSlider_thumbButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : SliderThumb_upSkin,
				backgroundSkin_overSkin : SliderThumb_overSkin,
				backgroundSkin_downSkin : SliderThumb_downSkin,
				backgroundSkin_disabledSkin : SliderThumb_upSkin
			}
			//-----------------------------------------------------------------|
			
			//HDividedContainer
			//----------------------------------------------------------------->
			css.HDividedContainer =
			{
				backgroundSkin : DefaultBackgroundSkin,
				backgroundSkin_backgroundAlpha : 1,
				backgroundSkin_backgroundColor : 0xFFFFFF,
				dividerButton_StyleName : "HDividedContainer_dividerButton_StyleName",
				dividerCursorSkin : HDividedContainer_cursorSkin,
				divideIndicatorSkin : HDividedContainer_divideIndicatorSkin,
				dividerThickness : 20
			}
			
			//---->
			
			css.HDividedContainer_dividerButton_StyleName =
			{
				backgroundSkin : EmptySkin,
				iconSkin : HDividedContainer_dividerSkin
			}
			//-----------------------------------------------------------------|
			
			/**IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII**/
			
			//ImageLoader
			//----------------------------------------------------------------->
			css.ImageLoader =
			{
					horizontalAlign : "center",
					verticalAlign : "middle",
					
					brokenSkin : Loader_brokenImageSkin
			}
			//-----------------------------------------------------------------|
			
			//ItemRender
			//----------------------------------------------------------------->
			css.ItemRender =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : null,
				backgroundSkin_overSkin : ItemRender_backgroundSkin_rollOverSkin,
				backgroundSkin_downSkin : ItemRender_backgroundSkin_rollOverSkin,
				backgroundSkin_selected_upSkin : ItemRender_backgroundSkin_selectedSkin,
				backgroundSkin_selected_overSkin : ItemRender_backgroundSkin_selectedSkin,
				backgroundSkin_selected_downSkin : ItemRender_backgroundSkin_selectedSkin
			}
			//-----------------------------------------------------------------|
			
			/**JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ**/
			
			/**KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK**/
			
			/**LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL**/
			
			/**MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM**/
			
			//Menu
			//----------------------------------------------------------------->
			css.Menu =
			{
				borderSkin_dropShadowVisible : true,
				borderSkin_dropShadowAlpha : 0.4,
				borderSkin_dropShadowAngle : 90,
				borderSkin_dropShadowBlur : 9,
				borderSkin_dropShadowColor : 0x000000,
				borderSkin_dropShadowDistance : 0,
				borderSkin_dropShadowStrength : 2
			}
			//-----------------------------------------------------------------|
			
			//MenuItemRenderer
			//----------------------------------------------------------------->
			css.MenuItemRenderer =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : null,
				backgroundSkin_overSkin : ItemRender_backgroundSkin_rollOverSkin,
				backgroundSkin_downSkin : ItemRender_backgroundSkin_rollOverSkin,
				backgroundSkin_selected_upSkin : null,
				backgroundSkin_selected_overSkin : ItemRender_backgroundSkin_rollOverSkin,
				backgroundSkin_selected_downSkin : ItemRender_backgroundSkin_rollOverSkin,
				
				checkIconSkin : new ClassFactory(SkinsProgrammaticSkin, {width:7, height:7}),
				checkIconSkin_upSkin : null,
				checkIconSkin_overSkin : null,
				checkIconSkin_downSkin : null,
				checkIconSkin_disabledkin : null,
				checkIconSkin_selected_upSkin : Menu_checkSelectedIcon,
				checkIconSkin_selected_overSkin : Menu_checkSelectedIcon,
				checkIconSkin_selected_downSkin : Menu_checkSelectedIcon,
				checkIconSkin_selected_disabledSkin : Menu_checkSelectedDisabledIcon,
				
				radioIconSkin : new ClassFactory(SkinsProgrammaticSkin, {width:5, height:5}),
				radioIconSkin_upSkin : null,
				radioIconSkin_overSkin : null,
				radioIconSkin_downSkin : null,
				radioIconSkin_disabledkin : null,
				radioIconSkin_selected_upSkin : Menu_radioIcon,
				radioIconSkin_selected_overSkin : Menu_radioIcon,
				radioIconSkin_selected_downSkin : Menu_radioIcon,
				radioIconSkin_selected_disabledSkin : Menu_radioDisabledIcon,
				
				separatorSkin : Menu_separatorSkin,
				
				branchIconSkin : new ClassFactory(SkinsProgrammaticSkin, {width:4, height:8}),
				branchIconSkin_upSkin : Menu_branchIcon,
				branchIconSkin_overSkin : Menu_branchIcon,
				branchIconSkin_downSkin : Menu_branchIcon,
				branchIconSkin_disabledSkin : Menu_branchDisabledIcon,
				branchIconSkin_selected_upSkin : Menu_branchIcon,
				branchIconSkin_selected_overSkin : Menu_branchIcon,
				branchIconSkin_selected_downSkin : Menu_branchIcon,
				branchIconSkin_selected_disabledSkin : Menu_branchDisabledIcon,
				
				paddingLeft : 5,
				paddingRight : 5,
				paddingTop : 2,
				paddingBottom : 2,
				horizontalGap : 6
			}
			//-----------------------------------------------------------------|
			
			/**NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN**/
			
			//NumericStepper
			//----------------------------------------------------------------->
			css.NumericStepper =
			{
				decrementButton_backgroundSkin : SkinsProgrammaticSkin,
				decrementButton_backgroundSkin_upSkin : NumericStepperUpArrow_UpSkin,
				decrementButton_backgroundSkin_overSkin : NumericStepperUpArrow_OverSkin,
				decrementButton_backgroundSkin_downSkin : NumericStepperUpArrow_DownSkin,
				decrementButton_backgroundSkin_disabledSkin : NumericStepperUpArrow_DisabledSkin,
				
				incrementButton_backgroundSkin : SkinsProgrammaticSkin,
				incrementButton_backgroundSkin_upSkin : NumericStepperDownArrow_UpSkin,
				incrementButton_backgroundSkin_overSkin : NumericStepperDownArrow_OverSkin,
				incrementButton_backgroundSkin_downSkin : NumericStepperDownArrow_DownSkin,
				incrementButton_backgroundSkin_disabledSkin : NumericStepperDownArrow_DisabledSkin
			}
			//-----------------------------------------------------------------|
			
			/**OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO**/
			
			/**PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP**/
			
			//Panel
			//----------------------------------------------------------------->
			css.Panel =
			{
				backgroundSkin : null,//no need borderSkin instead
				borderSkin : new ClassFactory(DefaultBorderSkin, {width:300, height:200}),
				borderSkin_borderStyle : "solid",
				borderSkin_borderVisible : true,
				borderSkin_borderColor : 0x111111,
				borderSkin_borderWeight : 1,
				borderSkin_backgroundColor : 0xFFFFFF,
				borderSkin_backgroundAlpha : 1,
				borderSkin_dropShadowVisible : true,
				borderSkin_dropShadowAlpha : 0.4,
				borderSkin_dropShadowAngle : 90,
				borderSkin_dropShadowBlur : 9,
				borderSkin_dropShadowColor : 0x000000,
				borderSkin_dropShadowDistance : 0,
				borderSkin_dropShadowStrength : 2,
				
				titleBackgroundSkin : TitleBar_backgroundSkin
			}
			//-----------------------------------------------------------------|
			
			//PopUpButton
			//----------------------------------------------------------------->
			css.PopUpButton =
			{ 
				popUpSkin : SkinsProgrammaticSkin,
				popUpUpSkin : PopUpButton_upSkin,
				popUpOverSkin : PopUpButton_overSkin,
				popUpDownSkin : PopUpButton_downSkin,
				popUpDisabledSkin : PopUpButton_disabledSkin,
				
				arrowButtonSkin : SkinsProgrammaticSkin,
				arrowButtonUpSkin : PopUpButton_arrowButtonUpSkin,
				arrowButtonOverSkin : PopUpButton_arrowButtonOverSkin,
				arrowButtonDownSkin : PopUpButton_arrowButtonDownSkin,
				arrowButtonDisabledSkin : PopUpButton_arrowButtonDisabledSkin
			}
			//-----------------------------------------------------------------|
			
			/**QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ**/
			
			/**RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR**/
			
			//RadioButton
			//----------------------------------------------------------------->
			css.RadioButton =
			{
				backgroundSkin : null,
				iconSkin : SkinsProgrammaticSkin,
				iconSkin_upSkin : RadioButton_upIcon,
				iconSkin_overSkin : RadioButton_overIcon,
				iconSkin_downSkin : RadioButton_downIcon,
				iconSkin_disabledSkin : RadioButton_disabledIcon,
				iconSkin_selected_upSkin : RadioButtonSelected_upIcon,
				iconSkin_selected_overSkin : RadioButtonSelected_overIcon,
				iconSkin_selected_downSkin : RadioButtonSelected_downIcon,
				iconSkin_selected_disabledSkin : RadioButtonSelected_disabledIcon
			}
			//-----------------------------------------------------------------|
			
			/**SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS**/
			
			//SkinnableContainerBase
			//----------------------------------------------------------------->
			var SkinnableContainerBase:Function = function():void
			{
				this.backgroundSkin = new ClassFactory(DefaultBackgroundSkin, {width:300, height:200});
				this.backgroundSkin_backgroundAlpha = 1;
				this.backgroundSkin_backgroundColor = 0xFFFFFF;
			}
			css["SkinnableContainerBase"] = new SkinnableContainerBase;
			//-----------------------------------------------------------------|
			
			//SkinableComponent
			//----------------------------------------------------------------->
			css.SkinableComponent =
			{
				errorSkin : SkinableComponent_errorSkin,
				focusSkin : SkinableComponent_focusSkin
			}
			//-----------------------------------------------------------------|
			
			//SWFLoader
			//----------------------------------------------------------------->
			css.SWFLoader =
			{
				horizontalAlign : "center",
				verticalAlign : "middle",
				
				brokenSkin : Loader_brokenImageSkin
			}
			//-----------------------------------------------------------------|
			
			//Scroller
			//----------------------------------------------------------------->
			css.Scroller =
			{
				vScrollBar_styleName : "VScrollBar",
				hScrollBar_styleName : "HScrollBar",
				horizontalScrollPolicy : "auto",
				verticalScrollPolicy : "auto"
			}
			//-----------------------------------------------------------------|
			
			//SimpleProgressBar
			//----------------------------------------------------------------->
			css.SimpleProgressBar =
			{
				trackSkin : ProgressTrackSkin,
				barSkin : ProgressBarSkin
			}
			//-----------------------------------------------------------------|
			
			//Spinner
			//----------------------------------------------------------------->
			css.Spinner =
			{
				decrementButton_backgroundSkin : SkinsProgrammaticSkin,
				decrementButton_backgroundSkin_upSkin : SpinnerUpArrow_UpSkin,
				decrementButton_backgroundSkin_overSkin : SpinnerUpArrow_OverSkin,
				decrementButton_backgroundSkin_downSkin : SpinnerUpArrow_DownSkin,
				decrementButton_backgroundSkin_disabledSkin : SpinnerUpArrow_DisabledSkin,
				
				incrementButton_backgroundSkin : SkinsProgrammaticSkin,
				incrementButton_backgroundSkin_upSkin : SpinnerDownArrow_UpSkin,
				incrementButton_backgroundSkin_overSkin : SpinnerDownArrow_OverSkin,
				incrementButton_backgroundSkin_downSkin : SpinnerDownArrow_DownSkin,
				incrementButton_backgroundSkin_disabledSkin : SpinnerDownArrow_DisabledSkin
			}
			//-----------------------------------------------------------------|
			
			/**TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT**/
			
			//ToolTip
			//----------------------------------------------------------------->
			css.ToolTip =
			{
				borderSkin : DefaultBorderSkin,
				borderSkin_cornerRadius : 4,
				borderSkin_borderStyle : "solid",
				borderSkin_borderVisible : true,
				borderSkin_borderColor : 0xFEFFDD,
				borderSkin_borderAlpha : 1,
				borderSkin_borderWeight : 4,
				
				borderSkin_dropShadowVisible : true,
				borderSkin_dropShadowAlpha : 0.2,
				borderSkin_dropShadowAngle : 90,
				borderSkin_dropShadowBlur : 6,
				borderSkin_dropShadowColor : 0x000000,
				borderSkin_dropShadowDistance : 4,
				borderSkin_dropShadowStrength : 2,
				
				paddingLeft : 2,
				paddingRight : 2,
				paddingTop : 2,
				paddingBottom : 2
			}

			//-----------------------------------------------------------------|
			
			//TitleWindow
			//----------------------------------------------------------------->
			css.TitleWindow =
			{
				closeButtonStyleName : "TitleWindow_closeButtonStyleName"
			}
			
			//---->
			
			css.TitleWindow_closeButtonStyleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : TitleWindow_CloseButtonUp,
				backgroundSkin_overSkin : TitleWindow_CloseButtonOver,
				backgroundSkin_downSkin : TitleWindow_CloseButtonDown,
				backgroundSkin_disabledSkin : TitleWindow_CloseButtonDisabled
			}
			//-----------------------------------------------------------------|
			
			//TextInput
			//----------------------------------------------------------------->
			css.TextInput =
			{
				borderSkin : DefaultBorderSkin,
				borderSkin_cornerRadius : 0,
				borderSkin_borderStyle : "solid",
				borderSkin_borderVisible : true,
				borderSkin_borderColor : 0x111111,
				borderSkin_borderAlpha : 0.6,
				borderSkin_borderWeight : 1,
				borderSkin_backgroundColor : 0xFFFFFF,
				borderSkin_backgroundAlpha : 1,
				
				paddingLeft : 2,
				paddingRight : 2,
				paddingTop : 2,
				paddingBottom : 2
			}
			//-----------------------------------------------------------------|
			
			//Tree
			//----------------------------------------------------------------->
			css.Tree = 
			{
			}
			//-----------------------------------------------------------------|
			
			//TreeItemRenderer
			//----------------------------------------------------------------->
			css.TreeItemRenderer = 
			{
				leafIconSkin : Tree_defaultLeafIcon,
				
				folderIconSkin : SkinsProgrammaticSkin,
				folderIconSkin_closedSkin : Tree_folderClosedIcon,
				folderIconSkin_openedSkin : Tree_folderOpenIcon,
				
				branchIconSkin : SkinsProgrammaticSkin,
				branchIconSkin_closedSkin : Tree_disclosureClosedIcon,
				branchIconSkin_openedSkin : Tree_disclosureOpenIcon,
				
				isUseRelationWire : true,
				treeRelationWireSkin : TreeRelationWireSkin
			}
			//-----------------------------------------------------------------|
			
			/**UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU**/
			
			/**VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV**/
			
			//VRule
			//----------------------------------------------------------------->
			css.VRule =
			{
				strokeSkin : VRuleSkin,
				strokeSkin_shadowColor : 0xC4CCCC,
				strokeSkin_strokeColor : 0xEEEEEE,
				strokeSkin_strokeWidth : 2
			}
			//-----------------------------------------------------------------|
			
			//VScrollBar
			//----------------------------------------------------------------->
			css.VScrollBar =
			{
				trackButton_styleName : "VScrollBar_trackButton_styleName",
				thumbButton_styleName : "VScrollBar_thumbButton_styleName",
				decrementButton_styleName : "VScrollBar_decrementButton_styleName",
				incrementButton_styleName : "VScrollBar_incrementButton_styleName",
				autoThumbVisibility : true
			}
			
			//---->
			
			css.VScrollBar_trackButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : VScrollTrack_Skin,
				backgroundSkin_overSkin : VScrollTrack_Skin,
				backgroundSkin_downSkin : VScrollTrack_Skin,
				backgroundSkin_disabledSkin : VScrollTrack_DisabledSkin
			}
			
			//---->
			
			css.VScrollBar_thumbButton_styleName =
			{
				paddingTop : 2,
				paddingBottom : 2,
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : VScrollThumb_upSkin,
				backgroundSkin_overSkin : VScrollThumb_overSkin,
				backgroundSkin_downSkin : VScrollThumb_downSkin,
				backgroundSkin_disabledSkin : VScrollThumb_upSkin,
				iconSkin : VScrollBar_thumbIcon
			}
			
			//---->
			
			css.VScrollBar_decrementButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : VScrollArrowUp_upSkin,
				backgroundSkin_overSkin : VScrollArrowUp_overSkin,
				backgroundSkin_downSkin : VScrollArrowUp_downSkin,
				backgroundSkin_disabledSkin : VScrollArrowUp_disabledSkin
			}
			
			//---->
			
			css.VScrollBar_incrementButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : VScrollArrowDown_upSkin,
				backgroundSkin_overSkin : VScrollArrowDown_overSkin,
				backgroundSkin_downSkin : VScrollArrowDown_downSkin,
				backgroundSkin_disabledSkin : VScrollArrowDown_disabledSkin
			}
			//-----------------------------------------------------------------|
			
			//VSlider
			//----------------------------------------------------------------->
			css.VSlider =
			{
				trackButton_styleName : "VSlider_trackButton_styleName",
				thumbButton_styleName : "VSlider_thumbButton_styleName",
				dataTip_styleName : "ToolTip",
				hightlightSkin : VSliderHighlight_Skin,
				slideDuration : 100,
				dataTipSideoffset : 5
			}
			
			//---->
			
			css.VSlider_trackButton_styleName =
			{
				backgroundSkin : VSliderTrack_Skin
			}
			
			//---->
			
			css.VSlider_thumbButton_styleName =
			{
				backgroundSkin : SkinsProgrammaticSkin,
				backgroundSkin_upSkin : SliderThumb_upSkin,
				backgroundSkin_overSkin : SliderThumb_overSkin,
				backgroundSkin_downSkin : SliderThumb_downSkin,
				backgroundSkin_disabledSkin : SliderThumb_upSkin
			}
			//-----------------------------------------------------------------|
			
			//VDividedContainer
			//----------------------------------------------------------------->
			css.VDividedContainer =
			{
				backgroundSkin : DefaultBackgroundSkin,
				backgroundSkin_backgroundAlpha : 1,
				backgroundSkin_backgroundColor : 0xFFFFFF,
				dividerButton_StyleName : "VDividedContainer_dividerButton_StyleName",
				dividerCursorSkin : VDividedContainer_cursorSkin,
				divideIndicatorSkin : VDividedContainer_divideIndicatorSkin,
				dividerThickness : 50
			}
			
			//---->
			
			css.VDividedContainer_dividerButton_StyleName =
			{
				backgroundSkin : EmptySkin,
				iconSkin : VDividedContainer_dividerSkin
			}
			//-----------------------------------------------------------------|
			
			/**WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW**/
			
			/**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX**/
			
			/**YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY**/
			
			/**ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ**/
			
			if(parameters[1] is IStyleManager)
			{
				IStyleManager(parameters[1]).initStyleByPropChian(css);
			}
			
			/******************************************************************/
			
			
			
			
			//Maybe Others Parts here...
			/******************************************************************/
			
			//...
			
			/******************************************************************/
			
			return css;
		}
	}
}
