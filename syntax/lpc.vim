" Vim syntax file
" Language:	LPC
" Maintainer:	Shizhu Pan <poet@mudbuilder.net>
" URL:		http://poet.tomud.com/pub/lpc.vim.bz2
" Last Change:	2011 Dec 10 by Thilo Six
" Comments:	If you are using Vim 6.2 or later, see :h lpc.vim for
"		file type recognizing, if not, you had to use modeline.


" Nodule: This is the start nodule. {{{1

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Nodule: Keywords {{{1

" LPC keywords
" keywords should always be highlighted so "contained" is not used.
syn cluster	lpcKeywdGrp	contains=lpcConditional,lpcLabel,lpcOperator,lpcRepeat,lpcStatement,lpcModifier,lpcReserved

syn keyword	lpcConditional	if else switch
syn keyword	lpcLabel	case default
syn keyword	lpcOperator	catch efun in
syn keyword     lpcKeyword      inherit
syn keyword	lpcRepeat	do for foreach while
syn keyword	lpcStatement	break continue return

syn match	lpcEfunError	/efun[^:]/ display

" Illegal to use keyword as function
" It's not working, maybe in the next version.
syn keyword	lpcKeywdError	contained if for foreach return switch while

" These are keywords only because they take lvalue or type as parameter,
" so these keywords should only be used as function but cannot be names of
" user-defined functions.
syn keyword	lpcKeywdFunc	new parse_command sscanf time_expression

" Nodule: Type and modifiers {{{1

" Type names list.

" Special types
syn keyword	lpcType		void mixed unknown
" Scalar/Value types.
syn keyword	lpcType		int float string
" Pointer types.
syn keyword	lpcType		array buffer class function mapping object
" Other types.
if exists("lpc_compat_32")
    syn keyword     lpcType	    closure status funcall
else
    syn keyword     lpcError	    closure status
    syn keyword     lpcType	    multiset
endif

" Type modifier.
syn keyword	lpcModifier	nomask private public
syn keyword	lpcModifier	varargs virtual

" sensible modifiers
if exists("lpc_pre_v22")
    syn keyword	lpcReserved	nosave protected ref
    syn keyword	lpcModifier	static
else
    syn keyword	lpcError	static
    syn keyword	lpcModifier	nosave protected ref
endif

" Nodule: Applies {{{1

" Match a function declaration or function pointer
syn match	lpcApplyDecl	excludenl /->\h\w*(/me=e-1 contains=lpcApplies transparent display

" We should note that in func_spec.c the efun definition syntax is so
" complicated that I use such a long regular expression to describe.
syn match	lpcLongDecl	excludenl /\(\s\|\*\)\h\+\s\h\+(/me=e-1 contains=@lpcEfunGroup,lpcType,@lpcKeywdGrp transparent display

" this is form for all functions
" ->foo() form had been excluded
syn match	lpcFuncDecl	excludenl /\h\w*(/me=e-1 contains=lpcApplies,@lpcEfunGroup,lpcKeywdError transparent display

" The (: :) parenthesis or $() forms a function pointer
syn match	lpcFuncName	/(:\s*\h\+\s*:)/me=e-1 contains=lpcApplies,@lpcEfunGroup transparent display contained
syn match	lpcFuncName	/(:\s*\h\+,/ contains=lpcApplies,@lpcEfunGroup transparent display contained
syn match	lpcFuncName	/\$(\h\+)/ contains=lpcApplies,@lpcEfunGroup transparent display contained

" Applies list.
"       system applies
syn keyword     lpcApplies      contained __INIT clean_up create destructor heart_beat id init move_or_destruct reset
"       interactive
syn keyword     lpcApplies      contained catch_tell logon net_dead process_input receive_message receive_snoop telnet_suboption terminal_type window_size write_prompt
"       master applies
syn keyword     lpcApplies      contained author_file compile_object connect crash creator_file domain_file epilog error_handler flag get_bb_uid get_root_uid get_save_file_name log_error make_path_absolute object_name preload privs_file retrieve_ed_setup save_ed_setup slow_shutdown
syn keyword     lpcApplies      contained valid_asm valid_bind valid_compile_to_c valid_database valid_hide valid_link valid_object valid_override valid_read valid_save_binary valid_seteuid valid_shadow valid_socket valid_write
"       parsing
syn keyword     lpcApplies      contained inventory_accessible inventory_visible is_living parse_command_adjectiv_id_list parse_command_adjective_id_list parse_command_all_word parse_command_id_list parse_command_plural_id_list parse_command_prepos_list parse_command_users parse_get_environment parse_get_first_inventory parse_get_next_inventory parser_error_message


" Nodule: Efuns {{{1

syn cluster	lpcEfunGroup	contains=lpc_efuns,lpcOldEfuns,lpcNewEfuns,lpcKeywdFunc

" Compat32 efuns
if exists("lpc_compat_32")
    syn keyword lpc_efuns	contained closurep heart_beat_info m_delete m_values m_indices query_once_interactive strstr
else
    syn match   lpcErrFunc	/#`\h\w*/
    " Shell compatible first line comment.
    syn region	lpcCommentFunc	start=/^#!/ end=/$/
endif

if exists("lpc_genesis")
" Genesis efuns
    syn keyword lpc_efuns	contained m_delete m_values m_indices 
    syn keyword lpc_efuns       contained query_screen_width abs acosh ftoa ftoi function_name readable_string applyv function_object reduce
    syn keyword lpc_efuns       contained asinh remove_alarm get_alarm atan2 get_all_alarms atanh restore_map atoi gettimeofday break_point
    syn keyword lpc_efuns       contained rnd itof save_map call_otherv call_self set_alarm call_selfv set_alarmv calling_function set_auth
    syn keyword lpc_efuns       contained calling_object m_delkey calling_program m_indexes m_sizeof cat set_screen_width cindent mappingp sinh
    syn keyword lpc_efuns       contained max min continue mkfunction sscanf cosh mkmapping switch debug nrnd
    syn keyword lpc_efuns       contained tail object_clones object_time tanh operator papplyv extract fact update_actions query_auth
    syn keyword lpc_efuns       contained file_time wildmatch query_interactive write_socket query_living_name
" Genesis lfuns
    syn keyword lpc_efuns       contained clean_up create init reset
" Genesis simul-efuns
    syn keyword lpc_efuns       contained minmax one_of_list get_localcmd write_vbfc setuid
endif

" pre-v22 efuns which are removed in newer versions.
syn keyword     lpcOldEfuns     contained tail dump_socket_status

" new efuns after v22 should be added here!
syn keyword     lpcNewEfuns     contained socket_status

" LPC efuns list.
" DEBUG efuns Not included.
" New efuns should NOT be added to this list, see v22 efuns above.
" Efuns list {{{2
syn keyword     lpc_efuns       contained acos add_action all_inventory all_previous_objects allocate allocate_buffer allocate_mapping apply arrayp asin atan author_stats
syn keyword     lpc_efuns       contained bind break_string bufferp
syn keyword     lpc_efuns       contained cache_stats call_other call_out call_out_info call_stack capitalize catch ceil check_memory children classp clear_bit clone_object clonep command commands copy cos cp crc32 crypt ctime
syn keyword     lpc_efuns       contained db_close db_commit db_connect db_exec db_fetch db_rollback db_status debug_info debugmalloc debug_message deep_inherit_list deep_inventory destruct disable_commands disable_wizard domain_stats dumpallobj dump_file_descriptors dump_prog
syn keyword     lpc_efuns       contained each ed ed_cmd ed_start enable_commands enable_wizard environment error errorp eval_cost evaluate exec exp explode export_uid external_start
syn keyword     lpc_efuns       contained fetch_variable file_length file_name file_size filter filter_array filter_mapping find_call_out find_living find_object find_player first_inventory floatp floor flush_messages function_exists function_owner function_profile functionp functions
syn keyword     lpc_efuns       contained generate_source get_char get_config get_dir geteuid getuid
syn keyword     lpc_efuns       contained heart_beats
syn keyword     lpc_efuns       contained id_matrix implode in_edit in_input inherit_list inherits input_to interactive intp
syn keyword     lpc_efuns       contained keys
syn keyword     lpc_efuns       contained link living livings load_object localtime log log10 lookat_rotate lower_case lpc_info
syn keyword     lpc_efuns       contained malloc_check malloc_debug malloc_status map map_array map_delete map_mapping mapp master match_path max_eval_cost member_array memory_info memory_summary message mkdir moncontrol move_object mud_status
syn keyword     lpc_efuns       contained named_livings network_stats next_bit next_inventory notify_fail nullp
syn keyword     lpc_efuns       contained objectp objects oldcrypt opcprof origin
syn keyword     lpc_efuns       contained parse_add_rule parse_add_synonym parse_command parse_dump parse_init parse_my_rules parse_refresh parse_remove parse_sentence pluralize pointerp pow present previous_object printf process_string process_value program_info
syn keyword     lpc_efuns       contained query_ed_mode query_heart_beat query_host_name query_idle query_ip_name query_ip_number query_ip_port query_load_average query_notify_fail query_privs query_replaced_program query_shadowing query_snoop query_snooping query_verb
syn keyword     lpc_efuns       contained random read_buffer read_bytes read_file receive reclaim_objects refs regexp reg_assoc reload_object remove_action remove_call_out remove_interactive remove_shadow rename repeat_string replace_program replace_string replaceable reset_eval_cost resolve restore_object restore_variable rm rmdir rotate_x rotate_y rotate_z rusage
syn keyword     lpc_efuns       contained save_object save_variable say scale set_author set_bit set_eval_limit set_heart_beat set_hide set_light set_living_name set_malloc_mask set_privs set_reset set_this_player set_this_user seteuid shadow shallow_inherit_list shout shutdown sin sizeof snoop socket_accept socket_acquire socket_address socket_bind socket_close socket_connect socket_create socket_error socket_listen socket_release socket_write sort_array sprintf sqrt stat store_variable strcmp stringp strlen strsrch
syn keyword     lpc_efuns       contained tan tell_object tell_room terminal_colour test_bit this_interactive this_object this_player this_user throw time to_float to_int trace traceprefix translate typeof
syn keyword     lpc_efuns       contained undefinedp unique_array unique_mapping upper_case uptime userp users
syn keyword     lpc_efuns       contained values variables virtualp
syn keyword     lpc_efuns       contained wizardp write write_buffer write_bytes write_file

" Nodule: Constants {{{1

" LPC Constants.
" like keywords, constants are always highlighted, be careful to choose only
" the constants we used to add to this list.

if exists("lpc_genesis")
  " All genesis related properties, formulas and definitions 
  " (at least those documented in mudlib)
  syn keyword     lpcConstant     CONT_I_ATTACH MAGIC_I_RES_LIGHT CONT_I_CLOSED
  syn keyword     lpcConstant     MAGIC_I_RES_MAGIC CONT_I_HEIGHT MAGIC_I_RES_POISON
  syn keyword     lpcConstant     CONT_I_HIDDEN MAGIC_I_RES_WATER
  syn keyword     lpcConstant     CONT_I_HOLDS_COMPONENTS NPC_I_NO_FEAR CONT_I_IN
  syn keyword     lpcConstant     NPC_I_NO_FEAR_CHECK CONT_I_LIGHT NPC_I_NO_LOOKS
  syn keyword     lpcConstant     CONT_I_LOCK NPC_I_NO_RUN_AWAY CONT_I_MAX_VOLUME
  syn keyword     lpcConstant     NPC_I_NO_UNARMED CONT_I_MAX_WEIGHT
  syn keyword     lpcConstant     NPC_M_NO_ACCEPT_GIVE CONT_I_REDUCE_VOLUME
  syn keyword     lpcConstant     OBJ_I_ALIGN CONT_I_REDUCE_WEIGHT OBJ_I_BROKEN
  syn keyword     lpcConstant     CONT_I_RIGID OBJ_I_CONTAIN_WATER CONT_I_TRANSP
  syn keyword     lpcConstant     OBJ_I_HAS_FIRE CONT_I_VOLUME OBJ_I_HIDE
  syn keyword     lpcConstant     CONT_I_WEIGHT OBJ_I_INVIS CONT_M_IN
  syn keyword     lpcConstant     OBJ_I_IS_MAGIC_ARMOUR CONT_M_NO_INS
  syn keyword     lpcConstant     OBJ_I_IS_MAGIC_WEAPON CONT_M_NO_REM OBJ_I_LIGHT
  syn keyword     lpcConstant     CORPSE_AS_KILLER OBJ_I_RES_ACID
  syn keyword     lpcConstant     CORPSE_S_LIVING_FILE OBJ_I_RES_AIR CORPSE_S_RACE
  syn keyword     lpcConstant     OBJ_I_RES_COLD DOOR_I_HEIGHT OBJ_I_RES_DEATH
  syn keyword     lpcConstant     DOOR_I_KEY OBJ_I_RES_EARTH GUILD_AI_PREFS
  syn keyword     lpcConstant     OBJ_I_RES_ELECTRICITY GUILD_I_COUNT OBJ_I_RES_FIRE
  syn keyword     lpcConstant     GUILD_I_ZERO_USED OBJ_I_RES_IDENTIFY HEAP_I_IS
  syn keyword     lpcConstant     OBJ_I_RES_LIFE HEAP_I_UNIT_VALUE OBJ_I_RES_LIGHT
  syn keyword     lpcConstant     HEAP_I_UNIT_VOLUME OBJ_I_RES_MAGIC
  syn keyword     lpcConstant     HEAP_I_UNIT_WEIGHT OBJ_I_RES_POISON
  syn keyword     lpcConstant     HEAP_S_UNIQUE_ID OBJ_I_RES_WATER LIVE_AO_SPARRING
  syn keyword     lpcConstant     OBJ_I_SEARCH_TIME LIVE_AO_THIEF OBJ_I_VALUE
  syn keyword     lpcConstant     LIVE_AS_ATTACK_FUMBLE OBJ_I_VOLUME
  syn keyword     lpcConstant     LIVE_I_ALWAYSKNOWN OBJ_I_WEIGHT
  syn keyword     lpcConstant     LIVE_I_ATTACK_DELAY OBJ_M_HAS_MONEY
  syn keyword     lpcConstant     LIVE_I_ATTACK_THIEF OBJ_M_NO_ATTACK
  syn keyword     lpcConstant     LIVE_I_BACKSTABBING OBJ_M_NO_BUY LIVE_I_BLIND
  syn keyword     lpcConstant     OBJ_M_NO_DROP LIVE_I_GOT_BACKSTABBED OBJ_M_NO_GET
  syn keyword     lpcConstant     LIVE_I_IS OBJ_M_NO_GIVE LIVE_I_LAST_STEAL
  syn keyword     lpcConstant     OBJ_M_NO_INS LIVE_I_MAX_DRINK OBJ_M_NO_MAGIC
  syn keyword     lpcConstant     LIVE_I_MAX_EAT OBJ_M_NO_MAGIC_ATTACK
  syn keyword     lpcConstant     LIVE_I_MAX_INTOX OBJ_M_NO_SELL LIVE_I_MEDITATES
  syn keyword     lpcConstant     OBJ_M_NO_STEAL LIVE_I_MIN_INTOX OBJ_M_NO_TELEPORT
  syn keyword     lpcConstant     LIVE_I_NEVERKNOWN OBJ_S_SEARCH_FUN
  syn keyword     lpcConstant     LIVE_I_NON_FORGET OBJ_S_WIZINFO
  syn keyword     lpcConstant     LIVE_I_NON_REMEMBER PLAYER_AI_LAST_STATS
  syn keyword     lpcConstant     LIVE_I_NO_BODY PLAYER_I_AUTOLOAD_TIME
  syn keyword     lpcConstant     LIVE_I_NO_CORPSE PLAYER_I_LASTXP LIVE_I_NO_DRINK
  syn keyword     lpcConstant     PLAYER_I_LAST_NOTE LIVE_I_NO_GENDER_DESC
  syn keyword     lpcConstant     PLAYER_I_NEWBIE_HELPER LIVE_I_NO_INGEST
  syn keyword     lpcConstant     PLAYER_I_NO_NOTES LIVE_I_NO_STUN
  syn keyword     lpcConstant     PLAYER_I_SEE_ERRORS LIVE_I_QUICKNESS
  syn keyword     lpcConstant     PLAYER_MORE_LEN LIVE_I_SEE_DARK
  syn keyword     lpcConstant     PLAYER_S_TRANSED_FROM LIVE_I_SEE_INVIS
  syn keyword     lpcConstant     PRE_OBJ_MAGIC_RES LIVE_I_SNEAK README
  syn keyword     lpcConstant     LIVE_I_STUNNED ROOM_AO_DOOROB LIVE_I_UNDEAD
  syn keyword     lpcConstant     ROOM_AS_DOORID LIVE_I_VICTIM_ADDED_AWARENESS
  syn keyword     lpcConstant     ROOM_I_ALLOW_STEED LIVE_M_MOUTH_BLOCKED
  syn keyword     lpcConstant     ROOM_I_HIDE LIVE_M_NO_ACCEPT_GIVE ROOM_I_INSIDE
  syn keyword     lpcConstant     LIVE_M_NO_DRINK ROOM_I_IS LIVE_M_NO_INGEST
  syn keyword     lpcConstant     ROOM_I_LIGHT LIVE_M_NO_SCRY ROOM_I_NO_ALLOW_STEED
  syn keyword     lpcConstant     LIVE_M_NO_STUN ROOM_I_NO_CLEANUP
  syn keyword     lpcConstant     LIVE_M_STOP_FIGHTING ROOM_I_NO_EXTRA_DESC
  syn keyword     lpcConstant     LIVE_O_ENEMY_CLING ROOM_I_NO_EXTRA_EXIT
  syn keyword     lpcConstant     LIVE_O_LAST_KILL ROOM_I_NO_EXTRA_ITEM
  syn keyword     lpcConstant     LIVE_O_LAST_ROOM ROOM_I_TYPE LIVE_O_SPELL_ATTACK
  syn keyword     lpcConstant     ROOM_M_NO_ATTACK LIVE_O_STEED ROOM_M_NO_HIDE
  syn keyword     lpcConstant     LIVE_S_EXTRA_SHORT ROOM_M_NO_MAGIC
  syn keyword     lpcConstant     LIVE_S_LAST_MOVE ROOM_M_NO_MAGIC_ATTACK
  syn keyword     lpcConstant     LIVE_S_SOULEXTRA ROOM_M_NO_SCRY MAGIC_AM_ID_INFO
  syn keyword     lpcConstant     ROOM_M_NO_STEAL MAGIC_AM_MAGIC ROOM_M_NO_TELEPORT
  syn keyword     lpcConstant     MAGIC_I_BREATH_WATER ROOM_M_NO_TELEPORT_FROM
  syn keyword     lpcConstant     MAGIC_I_ILLUSION ROOM_M_NO_TELEPORT_TO
  syn keyword     lpcConstant     MAGIC_I_RES_ACID ROOM_S_DARK_LONG MAGIC_I_RES_AIR
  syn keyword     lpcConstant     ROOM_S_DARK_MSG MAGIC_I_RES_COLD
  syn keyword     lpcConstant     ROOM_S_EXIT_FROM_DESC MAGIC_I_RES_DEATH
  syn keyword     lpcConstant     ROOM_S_MAP_FILE MAGIC_I_RES_EARTH
  syn keyword     lpcConstant     TEMP_OBJ_ABOUT_TO_DESTRUCT MAGIC_I_RES_ELECTRICITY
  syn keyword     lpcConstant     TEMP_SUBLOC_SHOW_ONLY_THINGS MAGIC_I_RES_FIRE
  syn keyword     lpcConstant     WIZARD_AM_MAN_SEL_ARR MAGIC_I_RES_IDENTIFY
  syn keyword     lpcConstant     WIZARD_I_BUSY_LEVEL MAGIC_I_RES_ILLUSION
  syn keyword     lpcConstant     WIZARD_S_MAN_SEL_CHAPT MAGIC_I_RES_LIFE ABS
  syn keyword     lpcConstant     IS_HOLDABLE_OBJECT ADD_SPACE_TO_ADVERB
  syn keyword     lpcConstant     IS_KEY_OBJECT ADVERB_AT_POS IS_LAUNCH_OBJECT
  syn keyword     lpcConstant     ALIGN_IS_EVIL IS_LEFTOVER_OBJECT ALIGN_IS_GOOD
  syn keyword     lpcConstant     IS_LIVING_OBJECT ALIGN_IS_NEUTRAL IS_MAIL_ALIAS
  syn keyword     lpcConstant     ALIGN_NOT_EVIL IS_MOBILE_OBJECT ALIGN_NOT_GOOD
  syn keyword     lpcConstant     IS_MONSTER_OBJECT ALIGN_NOT_NEUTRAL
  syn keyword     lpcConstant     IS_OBJECT_OBJECT ART_NONMETNAME IS_PARALYZE_OBJECT
  syn keyword     lpcConstant     BIN2DEC IS_PLAYER_OBJECT BLANK_ADVERB
  syn keyword     lpcConstant     IS_POISON_OBJECT CAN_SEE IS_POTION_OBJECT
  syn keyword     lpcConstant     CAN_SEE_IN_A_ROOM IS_PROJECTILE_OBJECT
  syn keyword     lpcConstant     CAN_SEE_IN_ROOM IS_RECEPTACLE_OBJECT
  syn keyword     lpcConstant     CMDPARSE_IN_ITEM IS_RESISTANCE_OBJECT
  syn keyword     lpcConstant     CMDPARSE_ITEMLIST IS_ROOM_OBJECT CMDPARSE_ONE_ITEM
  syn keyword     lpcConstant     IS_ROPE_OBJECT CMDPARSE_PARALYZE_ALLOWED
  syn keyword     lpcConstant     IS_SCROLL_OBJECT CMDPARSE_PARALYZE_ALLOW_CMDS
  syn keyword     lpcConstant     IS_SPELLS_OBJECT CMDPARSE_PARALYZE_CMD_IS_ALLOWED
  syn keyword     lpcConstant     IS_TORCH_OBJECT CMDPARSE_WITH_ITEM
  syn keyword     lpcConstant     IS_WEAPON_OBJECT COMPOSITE IS_WEARABLE_OBJECT
  syn keyword     lpcConstant     COMPOSITE_DEAD IS_WORKROOM_OBJECT COMPOSITE_LIVE
  syn keyword     lpcConstant     LANG_ADDART COMPOSITE_OBLAST LANG_ART
  syn keyword     lpcConstant     COMPOSITE_SORT LANG_ASHORT COMPOSITE_WORDS
  syn keyword     lpcConstant     LANG_IS_OFFENSIVE COMPOSITE_WORDS_WITH
  syn keyword     lpcConstant     LANG_NUM2WORD CONVTIME LANG_NUMW CREATE_MAIL
  syn keyword     lpcConstant     LANG_ORD2EXT DEC2BIN LANG_ORD2WORD
  syn keyword     lpcConstant     DEFAULT_ADVERB_ARRAY LANG_ORDW EXPAND_LINE
  syn keyword     lpcConstant     LANG_POSS EXPAND_MAIL_ALIAS LANG_PSENT FILE_NAME
  syn keyword     lpcConstant     LANG_PWORD FILE_PATH LANG_SHORT
  syn keyword     lpcConstant     FILTER_ARMOUR_OBJECTS LANG_STRIPART
  syn keyword     lpcConstant     FILTER_ARROW_OBJECTS LANG_SWORD
  syn keyword     lpcConstant     FILTER_BOARD_OBJECTS LANG_THESHORT
  syn keyword     lpcConstant     FILTER_BOOK_OBJECTS LANG_VOWELS FILTER_BOW_OBJECTS
  syn keyword     lpcConstant     LANG_WNUM FILTER_CAN_SEE LANG_WORD
  syn keyword     lpcConstant     FILTER_COINS_OBJECTS LANG_WORD2NUM
  syn keyword     lpcConstant     FILTER_CONTAINER_OBJECTS LANG_WORD2ORD
  syn keyword     lpcConstant     FILTER_CORPSE_OBJECTS LOAD_ERR
  syn keyword     lpcConstant     FILTER_CREATURE_OBJECTS MASTER FILTER_DEAD
  syn keyword     lpcConstant     MASTER_HASH FILTER_DOOR_OBJECTS MASTER_OB
  syn keyword     lpcConstant     FILTER_DRINK_OBJECTS MAX FILTER_FILE MEMBER_ADVERB
  syn keyword     lpcConstant     FILTER_FOOD_OBJECTS METNAME FILTER_GENDER MIN
  syn keyword     lpcConstant     FILTER_HEAP_OBJECTS MONEY_ADD FILTER_HERB_OBJECTS
  syn keyword     lpcConstant     MONEY_COINS FILTER_HOLDABLE_OBJECTS MONEY_COL_TEXT
  syn keyword     lpcConstant     FILTER_IS_MORTAL MONEY_CONDENSE FILTER_IS_SEEN
  syn keyword     lpcConstant     MONEY_EXPAND FILTER_IS_WIZARD MONEY_MAKE
  syn keyword     lpcConstant     FILTER_KEY_OBJECTS MONEY_MAKE_HERE
  syn keyword     lpcConstant     FILTER_LAUNCH_OBJECTS MONEY_MERGE
  syn keyword     lpcConstant     FILTER_LEFTOVER_OBJECTS MONEY_MOVE FILTER_LIVE
  syn keyword     lpcConstant     MONEY_MOVE_COIN_TYPES FILTER_LIVING_OBJECTS
  syn keyword     lpcConstant     MONEY_PARSE FILTER_MOBILE_OBJECTS MONEY_PARSE_OB
  syn keyword     lpcConstant     FILTER_MONSTER_OBJECTS MONEY_SPLIT
  syn keyword     lpcConstant     FILTER_OBJECT_OBJECTS MONEY_TEXT FILTER_OTHER_LIVE
  syn keyword     lpcConstant     MONEY_TEXT_NUM FILTER_PARALYZE_OBJECTS
  syn keyword     lpcConstant     MONEY_TEXT_NUM_SPLIT FILTER_PLAYERS
  syn keyword     lpcConstant     MONEY_TEXT_SPLIT FILTER_PLAYER_OBJECTS
  syn keyword     lpcConstant     MONEY_WCOL_TEXT FILTER_POISON_OBJECTS NAME
  syn keyword     lpcConstant     FILTER_POTION_OBJECTS NAME_TO_RANDOM
  syn keyword     lpcConstant     FILTER_PRESENT NONMETNAME FILTER_PRESENT_LIVE
  syn keyword     lpcConstant     NORMAL_ACCESS FILTER_PROJECTILE_OBJECTS NO_ADVERB
  syn keyword     lpcConstant     FILTER_RACE NO_ADVERB_WITH_SPACE
  syn keyword     lpcConstant     FILTER_REAL_PLAYERS NO_DEFAULT_ADVERB
  syn keyword     lpcConstant     FILTER_RECEPTACLE_OBJECTS
  syn keyword     lpcConstant     NO_DEFAULT_ADVERB_WITH_SPACE
  syn keyword     lpcConstant     FILTER_RESISTANCE_OBJECTS OBJECT_HASH
  syn keyword     lpcConstant     FILTER_ROOM_OBJECTS OB_NAME FILTER_ROPE_OBJECTS
  syn keyword     lpcConstant     OB_NUM FILTER_SCROLL_OBJECTS OPT_AUTO_PWD
  syn keyword     lpcConstant     FILTER_SHOWN OPT_BLOOD FILTER_SPELLS_OBJECTS
  syn keyword     lpcConstant     OPT_BRIEF FILTER_TORCH_OBJECTS OPT_ECHO
  syn keyword     lpcConstant     FILTER_WEAPON_OBJECTS OPT_GAG_MISSES
  syn keyword     lpcConstant     FILTER_WEARABLE_OBJECTS OPT_MERCIFUL_COMBAT
  syn keyword     lpcConstant     FILTER_WORKROOM_OBJECTS OPT_MORE_LEN
  syn keyword     lpcConstant     FIND_NEIGHBOURS OPT_NO_FIGHTS FIND_NEIGHBOURS_SELF
  syn keyword     lpcConstant     OPT_SCREEN_WIDTH FIND_STR_IN_ARR OPT_UNARMED_OFF
  syn keyword     lpcConstant     FIND_STR_IN_OBJECT OPT_WHIMPY FORMAT_NAME
  syn keyword     lpcConstant     PARSE_COMMAND FORMAT_PLNAME PARSE_COMMAND_ONE
  syn keyword     lpcConstant     FO_COMPOSITE PARSE_COMMAND_SIZE FO_COMPOSITE_DEAD
  syn keyword     lpcConstant     PARSE_THIS FO_COMPOSITE_LIVE QCNAME FTPATH
  syn keyword     lpcConstant     QCOMPDEAD FULL_ADVERB QCOMPLIVE F_DARE_ATTACK
  syn keyword     lpcConstant     QCPNAME F_MAX_HP QCTNAME F_MAX_SCAR QCTPNAME
  syn keyword     lpcConstant     F_SCAR_DESCS QNAME F_VALUE_ALCO QPNAME
  syn keyword     lpcConstant     F_VALUE_ARMOUR QSHORT F_VALUE_WEAPON QTNAME
  syn keyword     lpcConstant     GET_ALL_ADVERBS QTPNAME GET_EXP_LEVEL_DESC
  syn keyword     lpcConstant     QUESTION_FILTER GET_NUM_DESC
  syn keyword     lpcConstant     REMOVE_SPACE_FROM_ADVERB GET_NUM_DESC_SUB
  syn keyword     lpcConstant     SD_AV_LEVELS GET_NUM_LEVEL_DESC SD_AV_TITLES
  syn keyword     lpcConstant     GET_PROC_DESC SD_IS_NEWBIE GET_PROC_DESC_SUB
  syn keyword     lpcConstant     SD_NEWBIE_INDEX GET_STAT_INDEX_DESC
  syn keyword     lpcConstant     SD_NEWBIE_LEVEL GET_STAT_LEVEL_DESC
  syn keyword     lpcConstant     SD_NEWBIE_TITLE G_FEMALE SERVICE_ADVERBS_ARRAY
  syn keyword     lpcConstant     G_MALE STAMP2TIME G_NEUTER STRING_HASH
  syn keyword     lpcConstant     HANGING_INDENT SUM_ARRAY INT_MULT_FLOAT
  syn keyword     lpcConstant     TART_NONMETNAME INT_MULT_FLOAT_ROUND TIME2FORMAT
  syn keyword     lpcConstant     INT_MULT_FLOAT_TRUNC TIME2NUM IN_ARRAY TIME2STR
  syn keyword     lpcConstant     IS_ARMOUR_OBJECT TIMESTAMP IS_ARROW_OBJECT
  syn keyword     lpcConstant     TOTAL_MONEY IS_BOARD_OBJECT T_ARRAY IS_BOOK_OBJECT
  syn keyword     lpcConstant     T_FLOAT IS_BOW_OBJECT T_FUNCTION IS_CLONE
  syn keyword     lpcConstant     T_INTEGER IS_COINS_OBJECT T_MAPPING
  syn keyword     lpcConstant     IS_CONTAINER_OBJECT T_OBJECT IS_CORPSE_OBJECT
  syn keyword     lpcConstant     T_STRING IS_CREATURE_OBJECT
  syn keyword     lpcConstant     VALID_DEF_START_LOCATION IS_DOOR_OBJECT
  syn keyword     lpcConstant     VALID_TEMP_START_LOCATION IS_DRINK_OBJECT VBFC
  syn keyword     lpcConstant     IS_FOOD_OBJECT VBFC_ME IS_HEAP_OBJECT
  syn keyword     lpcConstant     VISIBLE_ACCESS IS_HERB_OBJECT F_AC_MOD
  syn keyword     lpcConstant     F_HEAL_FORMULA F_AWARENESS_BONUS
  syn keyword     lpcConstant     F_KILL_ADJUST_ALIGN F_BACKSTAB_FATIGUE F_MAX_HP
  syn keyword     lpcConstant     F_BACKSTAB_HIT F_MAX_REMEMBERED
  syn keyword     lpcConstant     F_BACKSTAB_MIN_SKILL F_PANIC_DEPR_PROC
  syn keyword     lpcConstant     F_BACKSTAB_PEN F_PANIC_WIMP_LEVEL F_DAMAGE
  syn keyword     lpcConstant     F_PENMOD F_DARE_ATTACK F_RECOVERY_LIMIT
  syn keyword     lpcConstant     F_DEATH_MAX_EXP_PLATFORM F_RELAX_TIME_AFTER_COMBAT
  syn keyword     lpcConstant     F_DEATH_MIN_EXP_PLATFORM F_STEAL_EXP
  syn keyword     lpcConstant     F_DEATH_MIN_RELATIVE_BRUTE F_STEAL_MIN_SKILL
  syn keyword     lpcConstant     F_DEATH_RELATIVE_BRUTE_RANGE F_UNARMED_HIT
  syn keyword     lpcConstant     F_DIE_REDUCE_XP F_UNARMED_PEN F_EXP_HERBSEARCH
  syn keyword     lpcConstant     F_VALUE_ARMOUR F_EXP_ON_KILL F_VALUE_WEAPON
  syn keyword     lpcConstant     F_EXP_TEAM_BONUS F_WEIGHT_DEFAULT_ARMOUR
  syn keyword     lpcConstant     F_FATIGUE_FORMULA F_WEIGHT_DEFAULT_WEAPON
else
  syn keyword     lpcConstant     __ARCH__ __COMPILER__ __DIR__ __FILE__ __OPTIMIZATION__ __PORT__ __VERSION__
  "       Defines in options.h are all predefined in LPC sources surrounding by
  "       two underscores. Do we need to include all of that?
  syn keyword     lpcConstant     __SAVE_EXTENSION__ __HEARTBEAT_INTERVAL__
  "       from the documentation we know that these constants remains only for
  "       backward compatibility and should not be used any more.
  syn keyword     lpcConstant     HAS_ED HAS_PRINTF HAS_RUSAGE HAS_DEBUG_LEVEL
  syn keyword     lpcConstant     MUD_NAME F__THIS_OBJECT
endif

" Nodule: Todo for this file.  {{{1

" TODO : need to check for LPC4 syntax and other series of LPC besides
" v22, b21 and l32, if you had a good idea, contact me at poet@mudbuilder.net
" and I will be appreciated about that.

" Notes about some FAQ:
"
" About variables : We adopts the same behavior for C because almost all the
" LPC programmers are also C programmers, so we don't need separate settings
" for C and LPC. That is the reason why I don't change variables like
" "c_no_utf"s to "lpc_no_utf"s.
"
" Copy : Some of the following seems to be copied from c.vim but not quite
" the same in details because the syntax for C and LPC is different.
"
" Color scheme : this syntax file had been thouroughly tested to work well
" for all of the dark-backgrounded color schemes Vim has provided officially,
" and it should be quite Ok for all of the bright-backgrounded color schemes,
" of course it works best for the color scheme that I am using, download it
" from http://poet.tomud.com/pub/ps_color.vim.bz2 if you want to try it.
"

" Nodule: String and Character {{{1


" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	lpcSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match	lpcSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif

" LPC version of sprintf() format,
syn match	lpcFormat	display "%\(\d\+\)\=[-+ |=#@:.]*\(\d\+\)\=\('\I\+'\|'\I*\\'\I*'\)\=[OsdicoxXf]" contained
syn match	lpcFormat	display "%%" contained
syn region	lpcString	start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell,lpcSpecial,lpcFormat
" lpcCppString: same as lpcString, but ends at end of line
syn region	lpcCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=@Spell,lpcSpecial,lpcFormat

" LPC preprocessor for the text formatting short cuts
" Thanks to Dr. Charles E. Campbell <cec@gryphon.gsfc.nasa.gov>
"	he suggests the best way to do this.
syn region	lpcTextString	start=/@\z(\h\w*\)$/ end=/^\z1/ contains=@Spell,lpcSpecial
syn region	lpcArrayString	start=/@@\z(\h\w*\)$/ end=/^\z1/ contains=@Spell,lpcSpecial

" Character
syn match	lpcCharacter	"L\='[^\\]'"
syn match	lpcCharacter	"L'[^']*'" contains=lpcSpecial
syn match	lpcSpecialError	"L\='\\[^'\"?\\abefnrtv]'"
syn match	lpcSpecialCharacter "L\='\\['\"?\\abefnrtv]'"
syn match	lpcSpecialCharacter display "L\='\\\o\{1,3}'"
syn match	lpcSpecialCharacter display "'\\x\x\{1,2}'"
syn match	lpcSpecialCharacter display "L'\\x\x\+'"

" Nodule: White space {{{1

" when wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match	lpcSpaceError	display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match	lpcSpaceError	display " \+\t"me=e-1
  endif
endif

" Nodule: Parenthesis and brackets {{{1

" catch errors caused by wrong parenthesis and brackets
syn cluster	lpcParenGroup	contains=lpcParenError,lpcIncluded,lpcSpecial,lpcCommentSkip,lpcCommentString,lpcComment2String,@lpcCommentGroup,lpcCommentStartError,lpcUserCont,lpcUserLabel,lpcBitField,lpcCommentSkip,lpcOctalZero,lpcCppOut,lpcCppOut2,lpcCppSkip,lpcFormat,lpcNumber,lpcFloat,lpcOctal,lpcOctalError,lpcNumbersCom
syn region	lpcParen	transparent start='(' end=')' contains=ALLBUT,@lpcParenGroup,lpcCppParen,lpcErrInBracket,lpcCppBracket,lpcCppString,@lpcEfunGroup,lpcApplies,lpcKeywdError
" lpcCppParen: same as lpcParen but ends at end-of-line; used in lpcDefine
syn region	lpcCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@lpcParenGroup,lpcErrInBracket,lpcParen,lpcBracket,lpcString,@lpcEfunGroup,lpcApplies,lpcKeywdError
syn match	lpcParenError	display ")"
syn match	lpcParenError	display "\]"
" for LPC:
" Here we should consider the array ({ }) parenthesis and mapping ([ ])
" parenthesis and multiset (< >) parenthesis.
syn match	lpcErrInParen	display contained "[^^]{"ms=s+1
syn match	lpcErrInParen	display contained "\(}\|\]\)[^)]"me=e-1
syn region	lpcBracket	transparent start='\[' end=']' contains=ALLBUT,@lpcParenGroup,lpcErrInParen,lpcCppParen,lpcCppBracket,lpcCppString,@lpcEfunGroup,lpcApplies,lpcFuncName,lpcKeywdError
" lpcCppBracket: same as lpcParen but ends at end-of-line; used in lpcDefine
syn region	lpcCppBracket	transparent start='\[' skip='\\$' excludenl end=']' end='$' contained contains=ALLBUT,@lpcParenGroup,lpcErrInParen,lpcParen,lpcBracket,lpcString,@lpcEfunGroup,lpcApplies,lpcFuncName,lpcKeywdError
syn match	lpcErrInBracket	display contained "[);{}]"

" Nodule: Numbers {{{1

" integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	lpcNumbers	display transparent "\<\d\|\.\d" contains=lpcNumber,lpcFloat,lpcOctalError,lpcOctal
" Same, but without octal error (for comments)
syn match	lpcNumbersCom	display contained transparent "\<\d\|\.\d" contains=lpcNumber,lpcFloat,lpcOctal
syn match	lpcNumber	display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
" hex number
syn match	lpcNumber	display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match	lpcOctal	display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=lpcOctalZero
syn match	lpcOctalZero	display contained "\<0"
syn match	lpcFloat	display contained "\d\+f"
" floating point number, with dot, optional exponent
syn match	lpcFloat	display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
" floating point number, starting with a dot, optional exponent
syn match	lpcFloat	display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
" floating point number, without dot, with exponent
syn match	lpcFloat	display contained "\d\+e[-+]\=\d\+[fl]\=\>"
" flag an octal number with wrong digits
syn match	lpcOctalError	display contained "0\o*[89]\d*"
syn case match

" Nodule: Comment string {{{1

" lpcCommentGroup allows adding matches for special things in comments
syn match	lpcCommentTitle	contained "Function\s*:"
syn match	lpcCommentTitle	contained "Function name\s*:"
syn match	lpcCommentTitle	contained "Arguments\s*:"
syn match	lpcCommentTitle	contained "Argument\s*:"
syn match	lpcCommentTitle	contained "Notice\s*:"
syn match	lpcCommentTitle	contained "Returns\s*:"
syn match	lpcCommentTitle	contained "Description\s*:"
syn keyword	lpcTodo		contained TODO FIXME XXX NOTE
syn cluster	lpcCommentGroup	contains=lpcTodo,lpcCommentTitle

if exists("c_comment_strings")
  " A comment can contain lpcString, lpcCharacter and lpcNumber.
  syntax match	lpcCommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region lpcCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=lpcSpecial,lpcCommentSkip
  syntax region lpcComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=lpcSpecial
  syntax region  lpcCommentL	start="//" skip="\\$" end="$" keepend contains=@Spell,@lpcCommentGroup,lpcComment2String,lpcCharacter,lpcNumbersCom,lpcSpaceError
  syntax region lpcComment	matchgroup=lpcCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@Spell,@lpcCommentGroup,lpcCommentStartError,lpcCommentString,lpcCharacter,lpcNumbersCom,lpcSpaceError
else
  syn region	lpcCommentL	start="//" skip="\\$" end="$" keepend contains=@Spell,@lpcCommentGroup,lpcSpaceError
  syn region	lpcComment	matchgroup=lpcCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@Spell,@lpcCommentGroup,lpcCommentStartError,lpcSpaceError
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match	lpcCommentError	display "\*/"
syntax match	lpcCommentStartError display "/\*"me=e-1 contained

" Nodule: Pre-processor {{{1

syn region	lpcPreCondit	start="^\s*#\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=lpcComment,lpcCppString,lpcCharacter,lpcCppParen,lpcParenError,lpcNumbers,lpcCommentError,lpcSpaceError
syn match	lpcPreCondit	display "^\s*#\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  syn region	lpcCppOut		start="^\s*#\s*if\s\+0\+\>" end=".\|$" contains=lpcCppOut2
  syn region	lpcCppOut2	contained start="0" end="^\s*#\s*\(endif\>\|else\>\|elif\>\)" contains=lpcSpaceError,lpcCppSkip
  syn region	lpcCppSkip	contained start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*#\s*endif\>" contains=lpcSpaceError,lpcCppSkip
endif
syn region	lpcIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	lpcIncluded	display contained "<[^>]*>"
syn match	lpcInclude	display "^\s*#\s*include\>\s*["<]" contains=lpcIncluded
syn match lpcLineSkip	"\\$"
syn cluster	lpcPreProcGroup	contains=lpcPreCondit,lpcIncluded,lpcInclude,lpcDefine,lpcErrInParen,lpcErrInBracket,lpcUserLabel,lpcSpecial,lpcOctalZero,lpcCppOut,lpcCppOut2,lpcCppSkip,lpcFormat,lpcNumber,lpcFloat,lpcOctal,lpcOctalError,lpcNumbersCom,lpcString,lpcCommentSkip,lpcCommentString,lpcComment2String,@lpcCommentGroup,lpcCommentStartError,lpcParen,lpcBracket,lpcMulti,lpcKeywdError
syn region	lpcDefine	start="^\s*#\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 contains=ALLBUT,@lpcPreProcGroup

if exists("lpc_pre_v22")
    syn region	lpcPreProc	start="^\s*#\s*\(pragma\>\|echo\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@lpcPreProcGroup
else
    syn region	lpcPreProc	start="^\s*#\s*\(pragma\>\|echo\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@lpcPreProcGroup
endif

" Nodule: User labels {{{1

" Highlight Labels
" User labels in LPC is not allowed, only "case x" and "default" is supported
syn cluster	lpcMultiGroup	contains=lpcIncluded,lpcSpecial,lpcCommentSkip,lpcCommentString,lpcComment2String,@lpcCommentGroup,lpcCommentStartError,lpcUserCont,lpcUserLabel,lpcBitField,lpcOctalZero,lpcCppOut,lpcCppOut2,lpcCppSkip,lpcFormat,lpcNumber,lpcFloat,lpcOctal,lpcOctalError,lpcNumbersCom,lpcCppParen,lpcCppBracket,lpcCppString,lpcKeywdError
syn region	lpcMulti	transparent start='\(case\|default\|public\|protected\|private\)\>' skip='::' end=':' contains=ALLBUT,@lpcMultiGroup

syn cluster	lpcLabelGroup	contains=lpcUserLabel
syn match	lpcUserCont	display "^\s*lpc:$" contains=@lpcLabelGroup

" Don't want to match anything
syn match	lpcUserLabel	display "lpc" contained

" Nodule: Initializations {{{1

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50	" #if 0 constructs can be long
  else
    let b:c_minlines = 15	" mostly for () constructs
  endif
endif
exec "syn sync ccomment lpcComment minlines=" . b:c_minlines

" Make sure these options take place since we no longer depend on file type
" plugin for C
setlocal cindent
setlocal fo-=t fo+=croql
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

" Win32 can filter files in the browse dialog
if has("gui_win32") && !exists("b:browsefilter")
    let b:browsefilter = "LPC Source Files (*.c *.d *.h)\t*.c;*.d;*.h\n" .
	\ "LPC Data Files (*.scr *.o *.dat)\t*.scr;*.o;*.dat\n" .
	\ "Text Documentation (*.txt)\t*.txt\n" .
	\ "All Files (*.*)\t*.*\n"
endif

" Nodule: Highlight links {{{1

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lpc_syn_inits")
  if version < 508
    let did_lpc_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink lpcModifier		lpcStorageClass

  HiLink lpcQuotedFmt		lpcFormat
  HiLink lpcFormat		lpcSpecial
  HiLink lpcCppString		lpcString	" Cpp means
						" C Pre-Processor
  HiLink lpcCommentL		lpcComment
  HiLink lpcCommentStart	lpcComment
  HiLink lpcUserLabel		lpcLabel
  HiLink lpcSpecialCharacter	lpcSpecial
  HiLink lpcOctal		lpcPreProc
  HiLink lpcOctalZero		lpcSpecial  " LPC will treat octal numbers
					    " as decimals, programmers should
					    " be aware of that.
  HiLink lpcEfunError		lpcError
  HiLink lpcKeywdError		lpcError
  HiLink lpcOctalError		lpcError
  HiLink lpcParenError		lpcError
  HiLink lpcErrInParen		lpcError
  HiLink lpcErrInBracket	lpcError
  HiLink lpcCommentError	lpcError
  HiLink lpcCommentStartError	lpcError
  HiLink lpcSpaceError		lpcError
  HiLink lpcSpecialError	lpcError
  HiLink lpcErrFunc		lpcError

  if exists("lpc_pre_v22")
      HiLink lpcOldEfuns	lpc_efuns
      HiLink lpcNewEfuns	lpcError
  else
      HiLink lpcOldEfuns	lpcReserved
      HiLink lpcNewEfuns	lpc_efuns
  endif
  HiLink lpc_efuns		lpcFunction

  HiLink lpcReserved		lpcPreProc
  HiLink lpcTextString		lpcString   " This should be preprocessors, but
  HiLink lpcArrayString		lpcPreProc  " let's make some difference
					    " between text and array

  HiLink lpcIncluded		lpcString
  HiLink lpcCommentString	lpcString
  HiLink lpcComment2String	lpcString
  HiLink lpcCommentSkip		lpcComment
  HiLink lpcCommentFunc		lpcComment

  HiLink lpcCppSkip		lpcCppOut
  HiLink lpcCppOut2		lpcCppOut
  HiLink lpcCppOut		lpcComment

  " Standard type below
  HiLink lpcApplies		Special
  HiLink lpcCharacter		Character
  HiLink lpcCommentTitle        PreProc
  HiLink lpcComment		Comment
  HiLink lpcConditional		Conditional
  HiLink lpcConstant		Constant
  HiLink lpcDefine		Macro
  HiLink lpcError		Error
  HiLink lpcFloat		Float
  HiLink lpcFunction		Function
  HiLink lpcIdentifier		Identifier
  HiLink lpcInclude		Include
  HiLink lpcLabel		Label
  HiLink lpcNumber		Number
  HiLink lpcOperator		Operator
  HiLink lpcPreCondit		PreCondit
  HiLink lpcPreProc		PreProc
  HiLink lpcRepeat		Repeat
  HiLink lpcStatement		Statement
  HiLink lpcStorageClass	StorageClass
  HiLink lpcString		String
  HiLink lpcStructure		Structure
  HiLink lpcSpecial		LineNr
  HiLink lpcTodo		Todo
  HiLink lpcType		Type
  HiLink lpcKeyword             Keyword

  delcommand HiLink
endif

" Nodule: This is the end nodule. {{{1

let b:current_syntax = "lpc"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:ts=8:nosta:sw=2:ai:si:
" vim600:set fdm=marker: }}}1
