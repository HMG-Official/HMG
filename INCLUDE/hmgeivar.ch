//h_init.prg

#ifndef _NOHELP_
#define _NOHELP_
#endif
#ifndef _HGX_IVAR_
  #define _HGX_IVAR_

#xtranslate  _HMG_Control_TYPE <nindex> => ;
  m->_HMG_SYSDATA\[ 1 ,<nindex> \]

#xtranslate _HMG_aControlType          => m->_HMG_SYSDATA\[1\]
#xtranslate _HMG_aControlNames         => m->_HMG_SYSDATA\[2\]
#xtranslate _HMG_aControlHandles       => m->_HMG_SYSDATA\[3\]
#xtranslate _HMG_aControlParenthandles => m->_HMG_SYSDATA\[4\]

#xtranslate _HMG_aControlIds => m->_HMG_SYSDATA\[5\] //------------

#xtranslate _HMG_aControlProcedures => m->_HMG_SYSDATA\[6\]

#xtranslate _HMG_aControlPageMap => m->_HMG_SYSDATA\[7\] // ----------
#xtranslate _HMG_aControlValue      => m->_HMG_SYSDATA\[8\]
#xtranslate _HMG_aControlInputMask   => m->_HMG_SYSDATA\[9\]

#xtranslate _HMG_aControllostFocusProcedure => m->_HMG_SYSDATA\[10\]
#xtranslate _HMG_aControlGotFocusProcedure  => m->_HMG_SYSDATA\[11\]
#xtranslate _HMG_aControlChangeProcedure    => m->_HMG_SYSDATA\[12\]
#xtranslate _HMG_aControlDeleted      => m->_HMG_SYSDATA\[13\]
#xtranslate _HMG_aControlBkColor      => m->_HMG_SYSDATA\[14\]
#xtranslate _HMG_aControlFontColor      => m->_HMG_SYSDATA\[15\]

#xtranslate _HMG_aControlDblClick      => m->_HMG_SYSDATA\[16\]
#xtranslate _HMG_aControlHeadClick      => m->_HMG_SYSDATA\[17\]
#xtranslate _HMG_aControlRow         => m->_HMG_SYSDATA\[18\]
#xtranslate _HMG_aControlCol         => m->_HMG_SYSDATA\[19\]
#xtranslate _HMG_aControlWidth         => m->_HMG_SYSDATA\[20\]
#xtranslate _HMG_aControlHeight         => m->_HMG_SYSDATA\[21\]

#xtranslate _HMG_aControlSpacing      => m->_HMG_SYSDATA\[22\] //------
#xtranslate _HMG_aControlContainerRow      => m->_HMG_SYSDATA\[23\]
#xtranslate _HMG_aControlContainerCol      => m->_HMG_SYSDATA\[24\]
#xtranslate _HMG_aControlPicture         => m->_HMG_SYSDATA\[25\]
#xtranslate _HMG_aControlContainerHandle => m->_HMG_SYSDATA\[26\]     
#xtranslate _HMG_aControlFontName      => m->_HMG_SYSDATA\[27\]
#xtranslate _HMG_aControlFontSize      => m->_HMG_SYSDATA\[28\]
#xtranslate _HMG_aControlFontAttributes => m->_HMG_SYSDATA\[29\]
#xtranslate _HMG_aControlToolTip      => m->_HMG_SYSDATA\[30\]

#xtranslate _HMG_aControlRangeMin      => m->_HMG_SYSDATA\[31\]
#xtranslate _HMG_aControlRangeMax      => m->_HMG_SYSDATA\[32\]
#xtranslate _HMG_aControlCaption      => m->_HMG_SYSDATA\[33\] //---------
#xtranslate _HMG_aControlVisible      => m->_HMG_SYSDATA\[34\]
#xtranslate _HMG_aControlHelpId        => m->_HMG_SYSDATA\[35\]

#xtranslate _HMG_aControlFontHandle   => m->_HMG_SYSDATA\[36\]
#xtranslate _HMG_aControlBrushHandle  => m->_HMG_SYSDATA\[37\]

#xtranslate _HMG_aControlEnabled      => m->_HMG_SYSDATA\[38\] //---------
#xtranslate _HMG_aControlMiscData1      => m->_HMG_SYSDATA\[39\]
#xtranslate _HMG_aControlMiscData2      => m->_HMG_SYSDATA\[40\]
#xtranslate _HMG_aControlKeyMouseEvent => m->_HMG_SYSDATA\[41\] //{ OnKeyControlEventProc, OnMouseControlEventProc, ToolTip_CustomDrawData }

#xtranslate _HMG_InstallEventHandler   => m->_HMG_SYSDATA\[60\]
#xtranslate _HMG_InstallPropertyHandler => m->_HMG_SYSDATA\[61\]
#xtranslate _HMG_InstallMethodHandler => m->_HMG_SYSDATA\[62\]
#xtranslate _HMG_UserComponentProcess => m->_HMG_SYSDATA\[63\]


#xtranslate _HMG_aFormDeleted         => m->_HMG_SYSDATA\[65\]
#xtranslate _HMG_aFormNames         => m->_HMG_SYSDATA\[66\]
#xtranslate _HMG_aFormHandles         => m->_HMG_SYSDATA\[67\]
#xtranslate _HMG_aFormActive         => m->_HMG_SYSDATA\[68\]
#xtranslate _HMG_aFormType         => m->_HMG_SYSDATA\[69\]
#xtranslate _HMG_aFormParentHandle      => m->_HMG_SYSDATA\[70\]
#xtranslate _HMG_aFormReleaseProcedure      => m->_HMG_SYSDATA\[71\]
#xtranslate _HMG_aFormInitProcedure      => m->_HMG_SYSDATA\[72\]
#xtranslate _HMG_aFormToolTipHandle      => m->_HMG_SYSDATA\[73\]
#xtranslate _HMG_aFormContextMenuHandle      => m->_HMG_SYSDATA\[74\]
#xtranslate _HMG_aFormMouseDragProcedure   => m->_HMG_SYSDATA\[75\]
#xtranslate _HMG_aFormSizeProcedure      => m->_HMG_SYSDATA\[76\]
#xtranslate _HMG_aFormClickProcedure      => m->_HMG_SYSDATA\[77\]
#xtranslate _HMG_aFormMouseMoveProcedure   => m->_HMG_SYSDATA\[78\]
#xtranslate _HMG_aFormBkColor         => m->_HMG_SYSDATA\[79\]
#xtranslate _HMG_aFormPaintProcedure      => m->_HMG_SYSDATA\[80\]
#xtranslate _HMG_aFormNoShow         => m->_HMG_SYSDATA\[81\]
#xtranslate _HMG_aFormNotifyIconName      => m->_HMG_SYSDATA\[82\]
#xtranslate _HMG_aFormNotifyIconToolTip      => m->_HMG_SYSDATA\[83\]
#xtranslate _HMG_aFormNotifyIconLeftClick   => m->_HMG_SYSDATA\[84\]
#xtranslate _HMG_aFormGotFocusProcedure      => m->_HMG_SYSDATA\[85\]
#xtranslate _HMG_aFormLostFocusProcedure   => m->_HMG_SYSDATA\[86\]
#xtranslate _HMG_aFormReBarHandle      => m->_HMG_SYSDATA\[87\]
#xtranslate _HMG_aFormNotifyMenuHandle      => m->_HMG_SYSDATA\[88\]
#xtranslate _HMG_aFormBrowseList      => m->_HMG_SYSDATA\[89\]
#xtranslate _HMG_aFormSplitChildList      => m->_HMG_SYSDATA\[90\]
#xtranslate _HMG_aFormVirtualHeight      => m->_HMG_SYSDATA\[91\]
#xtranslate _HMG_aFormVirtualWidth      => m->_HMG_SYSDATA\[92\]
#xtranslate _HMG_aFormFocused         => m->_HMG_SYSDATA\[93\]
#xtranslate _HMG_aFormScrollUp         => m->_HMG_SYSDATA\[94\]
#xtranslate _HMG_aFormScrollDown      => m->_HMG_SYSDATA\[95\]
#xtranslate _HMG_aFormScrollLeft      => m->_HMG_SYSDATA\[96\]
#xtranslate _HMG_aFormScrollRight      => m->_HMG_SYSDATA\[97\]
#xtranslate _HMG_aFormHScrollBox      => m->_HMG_SYSDATA\[98\]
#xtranslate _HMG_aFormVScrollBox      => m->_HMG_SYSDATA\[99\]
#xtranslate _HMG_aFormBrushHandle      => m->_HMG_SYSDATA\[100\]
#xtranslate _HMG_aFormFocusedControl      => m->_HMG_SYSDATA\[101\]
#xtranslate _HMG_aFormGraphTasks      => m->_HMG_SYSDATA\[102\]
#xtranslate _HMG_aFormMaximizeProcedure      => m->_HMG_SYSDATA\[103\]
#xtranslate _HMG_aFormMinimizeProcedure      => m->_HMG_SYSDATA\[104\]
//#xtranslate _HMG_aFormRestoreProcedure      => m->_HMG_SYSDATA\[105\]
#xtranslate _HMG_aFormAutoRelease => m->_HMG_SYSDATA\[105\]
#xtranslate _HMG_aFormInteractiveCloseProcedure   => m->_HMG_SYSDATA\[106\]
#xtranslate _HMG_aFormActivateId   => m->_HMG_SYSDATA\[107\] // 252

#xtranslate _HMG_aLangButton             => m->_HMG_SYSDATA\[128\]  // 267
#xtranslate _HMG_aLangLabel         => m->_HMG_SYSDATA\[129\]
#xtranslate _HMG_aLangUser         => m->_HMG_SYSDATA\[130\]
#xtranslate _HMG_aABMLangUser         => m->_HMG_SYSDATA\[131\]
#xtranslate _HMG_aABMLangLabel        => m->_HMG_SYSDATA\[132\]
#xtranslate _HMG_aABMLangButton       => m->_HMG_SYSDATA\[133\]
#xtranslate _HMG_aABMLangError        => m->_HMG_SYSDATA\[134\]
#xtranslate _HMG_BRWLangButton         => m->_HMG_SYSDATA\[135\]  //230
#xtranslate _HMG_BRWLangError         => m->_HMG_SYSDATA\[136\]
#xtranslate _HMG_BRWLangMessage         => m->_HMG_SYSDATA\[137\]  // 261
#xtranslate _HMG_aTreeMap         => m->_HMG_SYSDATA\[138\]  // 9
#xtranslate _HMG_aTreeIdMap         => m->_HMG_SYSDATA\[139\]
#xtranslate _HMG_ActiveTabFullPageMap      => m->_HMG_SYSDATA\[140\]  //43
#xtranslate _HMG_ActiveTabCaptions      => m->_HMG_SYSDATA\[141\]
#xtranslate _HMG_ActiveTabCurrentPageMap   => m->_HMG_SYSDATA\[142\]

#xtranslate _hmg_CurrentStatusBarCaptions => m->_HMG_SYSDATA\[143\]
#xtranslate _hmg_CurrentStatusBarWidths => m->_HMG_SYSDATA\[144\]
#xtranslate _hmg_CurrentStatusBarImages => m->_HMG_SYSDATA\[145\]
#xtranslate _hmg_CurrentStatusBarStyles => m->_HMG_SYSDATA\[146\]
#xtranslate _hmg_CurrentStatusBarToolTips => m->_HMG_SYSDATA\[147\]
#xtranslate _hmg_CurrentStatusBarActions => m->_HMG_SYSDATA\[148\]
#xtranslate _HMG_MainIndex => m->_HMG_SYSDATA\[164\]
#xtranslate _hmg_CurrentStatusBarFontSize => m->_HMG_SYSDATA\[165\]
#xtranslate _hmg_UserWindowHandle      => m->_HMG_SYSDATA\[166\]  // 276
#xtranslate _hmg_activemodalhandle      => m->_HMG_SYSDATA\[167\]

#xtranslate _HMG_nTopic            => m->_HMG_SYSDATA\[168]  // 205\]
#xtranslate _HMG_xContextMenuButtonIndex   => m->_HMG_SYSDATA\[169\]  //198
#xtranslate _HMG_nMet            => m->_HMG_SYSDATA\[170\]   
#xtranslate _HMG_ActiveSplitChildIndex      => m->_HMG_SYSDATA\[171\]  //199

#xtranslate _HMG_xMainMenuHandle      => m->_HMG_SYSDATA\[172\]  //186
#xtranslate _HMG_xMainMenuParentHandle      => m->_HMG_SYSDATA\[173\]
#xtranslate _HMG_xMenuPopupLevel      => m->_HMG_SYSDATA\[174\] 

#xtranslate _HMG_xContextMenuHandle      => m->_HMG_SYSDATA\[175\] // 192
#xtranslate _HMG_xContextMenuParentHandle   => m->_HMG_SYSDATA\[176\]
#xtranslate _HMG_xContextPopupLevel       => m->_HMG_SYSDATA\[177\]

#xtranslate _HMG_ActiveTreeValue      => m->_HMG_SYSDATA\[178\]  //4
#xtranslate _HMG_ActiveTreeIndex      => m->_HMG_SYSDATA\[179\]
#xtranslate _HMG_ActiveTreeHandle      => m->_HMG_SYSDATA\[180\]
#xtranslate _HMG_MainHandle         => m->_HMG_SYSDATA\[181\]  //30
#xtranslate _HMG_ActiveFontSize         => m->_HMG_SYSDATA\[182\]  //36
#xtranslate _HMG_FrameLevel         => m->_HMG_SYSDATA\[183\]  //37
#xtranslate _HMG_ActiveTabPage         => m->_HMG_SYSDATA\[184\]  //42

#xtranslate _HMG_ActiveTabRow         => m->_HMG_SYSDATA\[185\]  //48
#xtranslate _HMG_ActiveTabCol         => m->_HMG_SYSDATA\[186\]
#xtranslate _HMG_ActiveTabWidth         => m->_HMG_SYSDATA\[187\]
#xtranslate _HMG_ActiveTabHeight      => m->_HMG_SYSDATA\[188\]
#xtranslate _HMG_ActiveTabValue         => m->_HMG_SYSDATA\[189\]
//        #xtranslate _HMG_ActiveTabFontName      => m->_HMG_SYSDATA\[53\]
#xtranslate _HMG_ActiveTabFontSize      => m->_HMG_SYSDATA\[190\]
#xtranslate _HMG_MouseRow         => m->_HMG_SYSDATA\[191\]  //31
#xtranslate _HMG_MouseCol         => m->_HMG_SYSDATA\[192\]
#xtranslate _HMG_MouseState         => m->_HMG_SYSDATA\[193\]  //90
#xtranslate _HMG_ThisFormIndex          => m->_HMG_SYSDATA\[194\]  //219
#xtranslate _HMG_ThisItemRowIndex      => m->_HMG_SYSDATA\[195\]  // 223
#xtranslate _HMG_ThisItemColIndex      => m->_HMG_SYSDATA\[196\]
#xtranslate _HMG_ThisItemCellRow      => m->_HMG_SYSDATA\[197\]
#xtranslate _HMG_ThisItemCellCol      => m->_HMG_SYSDATA\[198\]
#xtranslate _HMG_ThisItemCellWidth      => m->_HMG_SYSDATA\[199\]
#xtranslate _HMG_ThisItemCellHeight      => m->_HMG_SYSDATA\[200\]
#xtranslate _HMG_ThisQueryRowIndex      => m->_HMG_SYSDATA\[201\]  // 220
#xtranslate _HMG_ThisQueryColIndex      => m->_HMG_SYSDATA\[202\]
#xtranslate _HMG_ThisIndex         => m->_HMG_SYSDATA\[203\]  // 217

#xtranslate _HMG_ActiveToolBarFormName      => m->_HMG_SYSDATA\[210\]  // 272
#xtranslate _HMG_LANG_ID         => m->_HMG_SYSDATA\[211\]  // 270

#xtranslate _hmg_CurrentStatusBarParent => m->_HMG_SYSDATA\[211\]
#xtranslate _hmg_CurrentStatusBarFontName => m->_HMG_SYSDATA\[212\] 
#xtranslate _HMG_TempWindowName         => m->_HMG_SYSDATA\[214\]

#xtranslate _HMG_ActiveFormNameBak      => m->_HMG_SYSDATA\[215\]  //  21
#xtranslate _HMG_SplitLastControl      => m->_HMG_SYSDATA\[216\]
#xtranslate _HMG_ActiveHelpFile       => m->_HMG_SYSDATA\[217\]
#xtranslate _HMG_xMenuType         => m->_HMG_SYSDATA\[218\]  // 185
#xtranslate _HMG_ActiveIniFile         => m->_HMG_SYSDATA\[219\]  //  3
#xtranslate _HMG_xMainMenuParentName => m->_HMG_SYSDATA\[220\]  //  191
#xtranslate _HMG_xContextMenuParentName => m->_HMG_SYSDATA\[221\]  //  197
#xtranslate _HMG_ActiveSplitBoxParentFormName   => m->_HMG_SYSDATA\[222\]  // 25
#xtranslate _HMG_ActiveFormName         => m->_HMG_SYSDATA\[223\]  // 21
#xtranslate _HMG_ActiveFontName         => m->_HMG_SYSDATA\[224\]  // 35
#xtranslate _HMG_ActiveTabName         => m->_HMG_SYSDATA\[225\]  // 46
#xtranslate _HMG_ActiveTabParentFormName   => m->_HMG_SYSDATA\[226\]
#xtranslate _HMG_ActiveTabFontName      => m->_HMG_SYSDATA\[227\]  // 53
#xtranslate _HMG_ActiveTabToolTip      => m->_HMG_SYSDATA\[228\]  // 55
#xtranslate _HMG_ActiveTabMnemonic      => m->_HMG_SYSDATA\[229\]  // 62
#xtranslate _HMG_ThisQueryData         => m->_HMG_SYSDATA\[230\]  // 222
#xtranslate _HMG_ThisType         => m->_HMG_SYSDATA\[231\]  // 218
#xtranslate _HMG_ThisEventType         => m->_HMG_SYSDATA\[232\]  // 242

#xtranslate _HMG_ParentWindowActive  => m->_HMG_SYSDATA\[240\] 

#xtranslate _HMG_IsXP            => m->_HMG_SYSDATA\[250\]  //  271
#xtranslate _HMG_SetFocusExecuted      => m->_HMG_SYSDATA\[251\]  //  259
#xtranslate _HMG_InteractiveCloseStarted   => m->_HMG_SYSDATA\[252\]  //  258
#xtranslate _HMG_DateTextBoxActive      => m->_HMG_SYSDATA\[253\]  //  256
#xtranslate _HMG_BrowseSyncStatus      => m->_HMG_SYSDATA\[254\] // 250
#xtranslate _HMG_ExtendedNavigation      => m->_HMG_SYSDATA\[255\]  //  241
#xtranslate _HMG_IPE_CANCELLED         => m->_HMG_SYSDATA\[256\]  // 238
#xtranslate _HMG_DialogCancelled      => m->_HMG_SYSDATA\[257\]  //  237
#xtranslate _HMG_ActiveSplitBoxInverted      => m->_HMG_SYSDATA\[258\]  //  232
#xtranslate _HMG_ActiveTreeItemIds      => m->_HMG_SYSDATA\[259\]   //  11
#xtranslate _HMG_SplitChildActive      => m->_HMG_SYSDATA\[260\]  // 20
#xtranslate _HMG_ActiveToolBarBreak      => m->_HMG_SYSDATA\[261\]  //  23
#xtranslate _HMG_ActiveSplitBox         => m->_HMG_SYSDATA\[262\]
#xtranslate _HMG_MainActive         => m->_HMG_SYSDATA\[263\]   // 29
#xtranslate _HMG_BeginWindowActive      => m->_HMG_SYSDATA\[264\]  //  34
#xtranslate _HMG_BeginTabActive         => m->_HMG_SYSDATA\[265\]  // 41
#xtranslate _HMG_ActiveTabButtons      => m->_HMG_SYSDATA\[266\]  //  57
#xtranslate _HMG_ActiveTabFlat         => m->_HMG_SYSDATA\[267\]
#xtranslate _HMG_ActiveTabHotTrack      => m->_HMG_SYSDATA\[268\]
#xtranslate _HMG_ActiveTabVertical      => m->_HMG_SYSDATA\[269\]
#xtranslate _HMG_ActiveTabNoTabStop      => m->_HMG_SYSDATA\[270\]
#xtranslate _HMG_IsModalActive         => m->_HMG_SYSDATA\[271\]  // 91

#xtranslate _hmg_CurrentStatusBarFontBold => m->_HMG_SYSDATA\[272\]
#xtranslate _hmg_CurrentStatusBarFontItalic  => m->_HMG_SYSDATA\[273\]
#xtranslate _hmg_CurrentStatusBarFontUnderLine => m->_HMG_SYSDATA\[274\]
#xtranslate _hmg_CurrentStatusBarFontStrikeout => m->_HMG_SYSDATA\[275\]
#xtranslate _hmg_CurrentStatusBarTop  => m->_HMG_SYSDATA\[276\]

#xtranslate _HMG_SendDataCount         => m->_HMG_SYSDATA\[290\]  // 182
#xtranslate _HMG_CommPath         => m->_HMG_SYSDATA\[291\]
#xtranslate _HMG_StationName         => m->_HMG_SYSDATA\[292\]  //  181

#xtranslate _hmg_ActiveToolBarImageHeight => m->_HMG_SYSDATA\[300\]

#xtranslate _HMG_ActiveTabBold         => m->_HMG_SYSDATA\[301\]  //  245
#xtranslate _HMG_ActiveTabItalic      => m->_HMG_SYSDATA\[302\]
#xtranslate _HMG_ActiveTabUnderline      => m->_HMG_SYSDATA\[303\]
#xtranslate _HMG_ActiveTabStrikeout      => m->_HMG_SYSDATA\[304\]
#xtranslate _HMG_ActiveTabImages      => m->_HMG_SYSDATA\[305\]
#xtranslate _HMG_IsMultiple         => m->_HMG_SYSDATA\[306\]  // 215
#xtranslate _HMG_NodeIndex         => m->_HMG_SYSDATA\[307\]   // 8
#xtranslate _HMG_ActiveTabChangeProcedure   => m->_HMG_SYSDATA\[308\]   // 56

#xtranslate _hmg_ActiveToolBarButtonCount => m->_HMG_SYSDATA\[309\]
#xtranslate _hmg_ActiveToolBarHandle  => m->_HMG_SYSDATA\[310\]
#xtranslate _hmg_ActiveToolBarParentWindowName => m->_HMG_SYSDATA\[311\]
#xtranslate _hmg_ActiveToolBarParentWindowHandle => m->_HMG_SYSDATA\[312\]
#xtranslate _hmg_ActiveToolBarGripperText => m->_HMG_SYSDATA\[313\]
#xtranslate _hmg_ActiveToolBarBreak => m->_HMG_SYSDATA\[314\]
#xtranslate _hmg_ActiveToolBarImageWidth => m->_HMG_SYSDATA\[315\]
#xtranslate _HMG_ThisFormName => m->_HMG_SYSDATA\[316\]
#xtranslate _HMG_ThisControlName => m->_HMG_SYSDATA\[317\]
#xtranslate _HMG_THISItemCellValue => m->_HMG_SYSDATA\[318\]  // 229

#xtranslate _HMG_aEventInfo         => m->_HMG_SYSDATA\[330\]   // 257
#xtranslate _HMG_MESSAGE         => m->_HMG_SYSDATA\[331\]  // 262
#xtranslate _HMG_ActiveFrameParentFormName   => m->_HMG_SYSDATA\[332\] // 38
#xtranslate _HMG_ActiveFrameRow         => m->_HMG_SYSDATA\[333\]
#xtranslate _HMG_ActiveFrameCol         => m->_HMG_SYSDATA\[334\]
#xtranslate _HMG_xMenuPopuphandle      => m->_HMG_SYSDATA\[335\]  // 189
#xtranslate _HMG_xMenuPopupCaption      => m->_HMG_SYSDATA\[336\]
#xtranslate _HMG_NodeHandle         => m->_HMG_SYSDATA\[337\]   // 7
#xtranslate _HMG_ShowContextMenus      => m->_HMG_SYSDATA\[338\]  // 216
#xtranslate _HMG_InteractiveClose      => m->_HMG_SYSDATA\[339\]   // 184
#xtranslate _HMG_IPE_COL         => m->_HMG_SYSDATA\[340\]   // 239
#xtranslate _HMG_IPE_ROW         => m->_HMG_SYSDATA\[341\]
#xtranslate _HMG_DefaultFontName      => m->_HMG_SYSDATA\[342\]   // 212
#xtranslate _HMG_DefaultFontSize      => m->_HMG_SYSDATA\[343\]
#xtranslate _HMG_LastWIndowDefinition => m->_HMG_SYSDATA\[344\]  **

#xtranslate _Print_Job_Name => m->_HMG_SYSDATA\[358\]
#xtranslate PRINTER_DELTA_ZOOM  => m->_HMG_SYSDATA\[359\]
#xtranslate _hmg_printer_BasePageName  => m->_HMG_SYSDATA\[360\]
#xtranslate _hmg_printer_CurrentPageNumber => m->_HMG_SYSDATA\[361\]
#xtranslate _hmg_printer_SizeFactor => m->_HMG_SYSDATA\[362\]
#xtranslate _hmg_printer_Dx => m->_HMG_SYSDATA\[363\]
#xtranslate _hmg_printer_Dy => m->_HMG_SYSDATA\[364\]
#xtranslate _hmg_printer_Dz => m->_HMG_SYSDATA\[365\]
#xtranslate _hmg_printer_scrollstep => m->_HMG_SYSDATA\[366\]
#xtranslate _hmg_printer_zoomclick_xoffset => m->_HMG_SYSDATA\[367\]
#xtranslate _HMG_PRINTER_THUMBUPDATE => m->_HMG_SYSDATA\[368\]
#xtranslate _hmg_printer_thumbscroll  => m->_HMG_SYSDATA\[369\]
#xtranslate _hmg_printer_PrevPageNumber => m->_HMG_SYSDATA\[370\]
#xtranslate _hmg_printer_usermessages => m->_HMG_SYSDATA\[371\]
#xtranslate _hmg_printer_hdc_bak => m->_HMG_SYSDATA\[372\]
#xtranslate _hmg_printer_aPrinterProperties => m->_HMG_SYSDATA\[373\]
#xtranslate _hmg_printer_hdc => m->_HMG_SYSDATA\[374\]
#xtranslate _hmg_printer_name => m->_HMG_SYSDATA\[375\]
#xtranslate _hmg_printer_copies => m->_HMG_SYSDATA\[376\]
#xtranslate _hmg_printer_collate => m->_HMG_SYSDATA\[377\]
#xtranslate _hmg_printer_preview => m->_HMG_SYSDATA\[378\]
#xtranslate _hmg_printer_timestamp => m->_HMG_SYSDATA\[379\]
#xtranslate _hmg_printer_PageCount => m->_HMG_SYSDATA\[380\]

#xtranslate _HMG_ActiveControlNoAutoSizeMovie      => m->_HMG_SYSDATA\[381\]  // 394
#xtranslate _HMG_ActiveControlFields         => m->_HMG_SYSDATA\[385\]  // 384

#xtranslate _HMG_ActiveControlColumnWhen => m->_HMG_SYSDATA\[386\]
#xtranslate _HMG_ActiveControlColumnValid => m->_HMG_SYSDATA\[387\]
#xtranslate _HMG_ActiveControlEditControls => m->_HMG_SYSDATA\[388\]
#xtranslate _HMG_ActiveControlWhen         => m->_HMG_SYSDATA\[389\]   // 297
#xtranslate _HMG_ActiveControlDynamicForeColor      => m->_HMG_SYSDATA\[390\]
#xtranslate _HMG_ActiveControlDynamicBackColor      => m->_HMG_SYSDATA\[391\]
#xtranslate _HMG_ActiveControlHandCursor      => m->_HMG_SYSDATA\[392\]   // 287
#xtranslate _HMG_ActiveControlCenterAlign      => m->_HMG_SYSDATA\[393\]
#xtranslate _HMG_ActiveControlNoHScroll         => m->_HMG_SYSDATA\[394\]
#xtranslate _HMG_ActiveControlGripperText      => m->_HMG_SYSDATA\[395\]
#xtranslate _HMG_ActiveControlDisplayEdit      => m->_HMG_SYSDATA\[396\]
#xtranslate _HMG_ActiveControlDisplayChange      => m->_HMG_SYSDATA\[397\]
#xtranslate _HMG_ActiveControlNoVScroll         => m->_HMG_SYSDATA\[398\]
#xtranslate _HMG_ActiveControlForeColor         => m->_HMG_SYSDATA\[399\]   // 295
#xtranslate _HMG_ActiveControlDateType         => m->_HMG_SYSDATA\[400\]
#xtranslate _HMG_ActiveControlInPlaceEdit      => m->_HMG_SYSDATA\[401\]   // 300
#xtranslate _HMG_ActiveControlItemSource      => m->_HMG_SYSDATA\[402\]
#xtranslate _HMG_ActiveControlValueSource      => m->_HMG_SYSDATA\[403\]
#xtranslate _HMG_ActiveControlWrap         => m->_HMG_SYSDATA\[404\]
#xtranslate _HMG_ActiveControlIncrement         => m->_HMG_SYSDATA\[405\]
#xtranslate _HMG_ActiveControlAddress         => m->_HMG_SYSDATA\[406\]
#xtranslate _HMG_ActiveControlItemCount         => m->_HMG_SYSDATA\[407\]
#xtranslate _HMG_ActiveControlOnQueryData      => m->_HMG_SYSDATA\[408\]
#xtranslate _HMG_ActiveControlAutoSize         => m->_HMG_SYSDATA\[409\]
#xtranslate _HMG_ActiveControlVirtual         => m->_HMG_SYSDATA\[410\]

#xtranslate _HMG_ActiveControlStretch         => m->_HMG_SYSDATA\[411\]   // 311
#xtranslate _HMG_ActiveControlFontBold         => m->_HMG_SYSDATA\[412\]
#xtranslate _HMG_ActiveControlFontItalic      => m->_HMG_SYSDATA\[413\]
#xtranslate _HMG_ActiveControlFontStrikeOut      => m->_HMG_SYSDATA\[414\]
#xtranslate _HMG_ActiveControlFontUnderLine      => m->_HMG_SYSDATA\[415\]
#xtranslate _HMG_ActiveControlName         => m->_HMG_SYSDATA\[416\]
#xtranslate _HMG_ActiveControlOf         => m->_HMG_SYSDATA\[417\]
#xtranslate _HMG_ActiveControlCaption         => m->_HMG_SYSDATA\[418\]
#xtranslate _HMG_ActiveControlAction         => m->_HMG_SYSDATA\[419\]
#xtranslate _HMG_ActiveControlWidth         => m->_HMG_SYSDATA\[420\]
#xtranslate _HMG_ActiveControlHeight         => m->_HMG_SYSDATA\[421\]
#xtranslate _HMG_ActiveControlFont         => m->_HMG_SYSDATA\[422\]
#xtranslate _HMG_ActiveControlSize         => m->_HMG_SYSDATA\[423\]
#xtranslate _HMG_ActiveControlTooltip         => m->_HMG_SYSDATA\[424\]
#xtranslate _HMG_ActiveControlFlat         => m->_HMG_SYSDATA\[425\]
#xtranslate _HMG_ActiveControlOnGotFocus      => m->_HMG_SYSDATA\[426\]
#xtranslate _HMG_ActiveControlOnLostFocus      => m->_HMG_SYSDATA\[427\]
#xtranslate _HMG_ActiveControlNoTabStop         => m->_HMG_SYSDATA\[428\]
#xtranslate _HMG_ActiveControlHelpId         => m->_HMG_SYSDATA\[429\]
#xtranslate _HMG_ActiveControlInvisible         => m->_HMG_SYSDATA\[430\]
#xtranslate _HMG_ActiveControlRow         => m->_HMG_SYSDATA\[431\]
#xtranslate _HMG_ActiveControlCol         => m->_HMG_SYSDATA\[432\]
#xtranslate _HMG_ActiveControlPicture         => m->_HMG_SYSDATA\[433\]
#xtranslate _HMG_ActiveControlValue         => m->_HMG_SYSDATA\[434\]
#xtranslate _HMG_ActiveControlOnChange         => m->_HMG_SYSDATA\[435\]

#xtranslate _HMG_ActiveControlItems         => m->_HMG_SYSDATA\[436\]   // 337
#xtranslate _HMG_ActiveControlOnEnter         => m->_HMG_SYSDATA\[437\]
#xtranslate _HMG_ActiveControlShowNone         => m->_HMG_SYSDATA\[438\]
#xtranslate _HMG_ActiveControlUpDown         => m->_HMG_SYSDATA\[439\]
#xtranslate _HMG_ActiveControlRightAlign      => m->_HMG_SYSDATA\[440\]
#xtranslate _HMG_ActiveControlReadOnly         => m->_HMG_SYSDATA\[441\]
#xtranslate _HMG_ActiveControlMaxLength         => m->_HMG_SYSDATA\[442\]
#xtranslate _HMG_ActiveControlBreak         => m->_HMG_SYSDATA\[443\]
#xtranslate _HMG_ActiveControlOpaque         => m->_HMG_SYSDATA\[444\]
#xtranslate _HMG_ActiveControlHeaders         => m->_HMG_SYSDATA\[445\]
#xtranslate _HMG_ActiveControlWidths         => m->_HMG_SYSDATA\[446\]
#xtranslate _HMG_ActiveControlOnDblClick      => m->_HMG_SYSDATA\[447\]
#xtranslate _HMG_ActiveControlOnHeadClick      => m->_HMG_SYSDATA\[448\]
#xtranslate _HMG_ActiveControlNoLines         => m->_HMG_SYSDATA\[449\]
#xtranslate _HMG_ActiveControlImage         => m->_HMG_SYSDATA\[450\]
#xtranslate _HMG_ActiveControlJustify         => m->_HMG_SYSDATA\[451\]
#xtranslate _HMG_ActiveControlNoToday         => m->_HMG_SYSDATA\[452\]
#xtranslate _HMG_ActiveControlNoTodayCircle      => m->_HMG_SYSDATA\[453\]
#xtranslate _HMG_ActiveControlWeekNumbers      => m->_HMG_SYSDATA\[454\]
#xtranslate _HMG_ActiveControlMultiSelect      => m->_HMG_SYSDATA\[455\]
#xtranslate _HMG_ActiveControlEdit         => m->_HMG_SYSDATA\[456\]
#xtranslate _HMG_ActiveControlBackColor         => m->_HMG_SYSDATA\[457\]
#xtranslate _HMG_ActiveControlFontColor         => m->_HMG_SYSDATA\[458\]
#xtranslate _HMG_ActiveControlBorder         => m->_HMG_SYSDATA\[459\]
#xtranslate _HMG_ActiveControlClientEdge      => m->_HMG_SYSDATA\[460\]
#xtranslate _HMG_ActiveControlHScroll         => m->_HMG_SYSDATA\[461\]
#xtranslate _HMG_ActiveControlVscroll         => m->_HMG_SYSDATA\[462\]
#xtranslate _HMG_ActiveControlTransparent      => m->_HMG_SYSDATA\[463\]

#xtranslate _HMG_ActiveControlSort         => m->_HMG_SYSDATA\[464\]  // 365
#xtranslate _HMG_ActiveControlRangeLow         => m->_HMG_SYSDATA\[465\]
#xtranslate _HMG_ActiveControlRangeHigh         => m->_HMG_SYSDATA\[466\]
#xtranslate _HMG_ActiveControlVertical         => m->_HMG_SYSDATA\[467\]
#xtranslate _HMG_ActiveControlSmooth         => m->_HMG_SYSDATA\[468\]
#xtranslate _HMG_ActiveControlOptions       => m->_HMG_SYSDATA\[469\]
#xtranslate _HMG_ActiveControlSpacing         => m->_HMG_SYSDATA\[470\]   // 373
#xtranslate _HMG_ActiveControlNoTicks         => m->_HMG_SYSDATA\[471\]
#xtranslate _HMG_ActiveControlBoth         => m->_HMG_SYSDATA\[472\]
#xtranslate _HMG_ActiveControlTop         => m->_HMG_SYSDATA\[473\]
#xtranslate _HMG_ActiveControlLeft         => m->_HMG_SYSDATA\[474\]
#xtranslate _HMG_ActiveControlUpperCase         => m->_HMG_SYSDATA\[475\]
#xtranslate _HMG_ActiveControlLowerCase         => m->_HMG_SYSDATA\[476\]
#xtranslate _HMG_ActiveControlNumeric         => m->_HMG_SYSDATA\[477\]
#xtranslate _HMG_ActiveControlPassword         => m->_HMG_SYSDATA\[478\]
#xtranslate _HMG_ActiveControlInputMask         => m->_HMG_SYSDATA\[479\]
#xtranslate _HMG_ActiveControlWorkArea         => m->_HMG_SYSDATA\[480\]
#xtranslate _HMG_ActiveControlFields         => m->_HMG_SYSDATA\[481\]
#xtranslate _HMG_ActiveControlDelete         => m->_HMG_SYSDATA\[482\]
#xtranslate _HMG_ActiveControlValid         => m->_HMG_SYSDATA\[483\]
#xtranslate _HMG_ActiveControlValidMessages      => m->_HMG_SYSDATA\[484\]
#xtranslate _HMG_ActiveControlLock         => m->_HMG_SYSDATA\[485\]
#xtranslate _HMG_ActiveControlAppendable      => m->_HMG_SYSDATA\[486\]
#xtranslate _HMG_ActiveControlFile         => m->_HMG_SYSDATA\[487\]
#xtranslate _HMG_ActiveControlAutoPlay         => m->_HMG_SYSDATA\[488\]
#xtranslate _HMG_ActiveControlCenter         => m->_HMG_SYSDATA\[489\]
#xtranslate _HMG_ActiveControlNoAutoSizeWindow      => m->_HMG_SYSDATA\[490\]
#xtranslate _HMG_ActiveControlNoAutoSizeMovie      => m->_HMG_SYSDATA\[491\]
#xtranslate _HMG_ActiveControlNoErrorDlg      => m->_HMG_SYSDATA\[492\]
#xtranslate _HMG_ActiveControlNoMenu         => m->_HMG_SYSDATA\[493\]
#xtranslate _HMG_ActiveControlNoOpen         => m->_HMG_SYSDATA\[494\]
#xtranslate _HMG_ActiveControlNoPlayBar         => m->_HMG_SYSDATA\[495\]
#xtranslate _HMG_ActiveControlShowAll         => m->_HMG_SYSDATA\[496\]
#xtranslate _HMG_ActiveControlShowMode         => m->_HMG_SYSDATA\[497\]
#xtranslate _HMG_ActiveControlShowName         => m->_HMG_SYSDATA\[498\]
#xtranslate _HMG_ActiveControlShowPosition      => m->_HMG_SYSDATA\[499\]
#xtranslate _HMG_ActiveControlFormat         => m->_HMG_SYSDATA\[500\]

#xtranslate _HMG_ScrollPage => m->_HMG_SYSDATA\[ 501\ ] //-> ScrollPage
#xtranslate _HMG_PrinterMetaFileDC => m->_HMG_SYSDATA\[ 502\ ] //-> #xtranslate --> _HMG_PrinterMetaFileDC
#xtranslate _HMG_FindReplaceOptions => m->_HMG_SYSDATA\[ 503\ ] //-> #xtranslate --> _HMG_FindReplaceOptions
#xtranslate _HMG_Position_of_Panel_Window => m->_HMG_SYSDATA\[ 504\ ] //-> {x,y,w,h}   --> Position of Panel Window
 
#xtranslate _HMG_PrintPreview_NotSaveButton => m->_HMG_SYSDATA\[ 505\ ] //-> PrintPreview NotSaveButton --> .T. or .F.
#xtranslate _HMG_PrintPreview_Dialog => m->_HMG_SYSDATA\[ 506\ ] //-> PrintPreview Dialog cFileName
#xtranslate _HMG_Print_SaveAs => m->_HMG_SYSDATA\[ 507\ ] //-> Print SaveAs cFullFileName
#xtranslate _HMG_Open_PrintPreview_Dialog => m->_HMG_SYSDATA\[ 508\ ] //-> Open PrintPreview Dialog  --> .T. or .F.
#xtranslate _HMG_ToolTip_CustomDraw => m->_HMG_SYSDATA\[ 509\ ] //-> ToolTip CustomDraw  --> .T. or .F.
#xtranslate _HMG_ToolTip_Menu => m->_HMG_SYSDATA\[ 510\ ] //-> ToolTip Menu --> .T. or .F.
#xtranslate _HMG_ToolTip_Menu_Handle => m->_HMG_SYSDATA\[ 511\ ] //-> ToolTip Menu Handle  --> { hWndToolTipMenu, ... }
#xtranslate _HMG_ToolTip_Form_Data => m->_HMG_SYSDATA\[ 512\ ] //-> ToolTip Form Data
#xtranslate _HMG_Default_Print_PDF_Mode => m->_HMG_SYSDATA\[ 513\ ] //-> Default Print PDF Mode --> .T. or .F.
#xtranslate _HMG_SetGridCustomDrawNewBehavior() => m->_HMG_SYSDATA\[ 514\ ] //-> SetGridCustomDrawNewBehavior() --> .T. or .F.
#xtranslate _HMG_OpenPrinterGetJobID() => m->_HMG_SYSDATA\[ 515\ ] //-> #xtranslate --> OpenPrinterGetJobID()
#xtranslate _HMG_STOREJOBDATA => m->_HMG_SYSDATA\[ 516\ ] //-> cVarName of STOREJOBDATA <aJobData>
#xtranslate _HMG_oString => m->_HMG_SYSDATA\[ 517\ ] //-> #xtranslate --> oString
#xtranslate _HMG_This_Cargo => m->_HMG_SYSDATA\[ 518\ ] //-> #xtranslate --> This.Cargo 

#xtranslate _HMG_winpos_xywh <nvalue> ;
 => m->_HMG_SYSDATA\[504\] <nvalue> 

#xtranslate _HMG_winpos_x <nvalue> => m->_HMG_SYSDATA\[504\] <nvalue> \[1\]
#xtranslate _HMG_winpos_y <nvalue> => m->_HMG_SYSDATA\[504\] <nvalue> \[2\]
#xtranslate _HMG_winpos_w <nvalue> => m->_HMG_SYSDATA\[504\] <nvalue> \[3\]
#xtranslate _HMG_winpos_h <nvalue> => m->_HMG_SYSDATA\[504\] <nvalue> \[4\]



 
#xtranslate _HMG_lOOPEnabled         => _HMX_DATA\[1\]
#xtranslate _HMG_bOnControlInit         => _HMX_DATA\[2\]
#xtranslate _HMG_bOnControlDestroy      => _HMX_DATA\[3\]

#xtranslate _HGX_F1help       => m->_hgx_data_\[1\]
#xtranslate _HGX_StopAllEvent => m->_hgx_data_\[2\]

#ifndef OBJ_FONT
  #define OBJ_FONT            6  // i_controlmisc.ch
#endif
#endif //_HGX_IVAR_

/*
#if ( __HARBOUR__ - 0 > 0x020000 )
   #xtranslate CurDrive() => hb_CurDrive()
   #xtranslate dbPack()   => hb_dbPack()
   #xtranslate dbZap()    => hb_dbZap()
#endif

#if ( __HARBOUR__ - 0 < 0x030200 )
   #xtranslate hb_IsFunction( <c> )       => ( Type( <c> + "()" ) == "UI" )
#  xtranslate hb_default( @<v>, <x> )     => iif( StrTran( ValType( <v> ), "M", "C" ) == StrTran( ValType( <x> ), "M", "C" ), Nil, <v> := <x> )
#  xtranslate hb_defaultValue( <v>, <x> ) => iif( StrTran( ValType( <v> ), "M", "C" ) == StrTran( ValType( <x> ), "M", "C" ), <v>, <x> )
#  xtranslate __defaultNIL( @<v>, <x> )   => ( <v> := iif( <v> == NIL, <x>, <v> ) )
#endif

#if ( __HARBOUR__ - 0 > 0x030200 )
   #xtranslate hb_oemtoansi( <x> )        => win_oemtoansi( <x> )
#endif
#  xtranslate IsDirectory( <c> )          => hb_DirExists( <c> )
#  xtranslate GetComputerName()           => NetName()
#  xtranslate GetUserName()               => hb_UserName()
#  xuntranslate AIns(                     =>
#  xuntranslate ADel(                     =>
#  xtranslate AIns( <a>, <n>, [<x,...>] ) => hb_AIns( <a>, <n>, <x> )
#  xtranslate ADel( <a>, <n>, <l> )       => hb_ADel( <a>, <n>, <l> )
*/