# Zen Browser keyboard shortcuts (Zen >= 1.25 uses Firefox CustomKeys).
# Written to <profile>/customKeys.json on `home-manager switch` while Zen is closed.
# Live view / test bindings: about:keyboard (changes there get overwritten on next switch).
#
# Value forms:
#   "default"                                    keep built-in binding (shown in comment)
#   "disabled"                                   unbind
#   { modifiers = "accel,shift"; key = "C"; }    rebind; use keycode = "VK_F5" for non-letter keys
# modifiers: accel (= Ctrl on Linux), control, alt, shift, meta; comma-separated, no spaces.
# Defaults dumped from zen-twilight 1.25t browser.xhtml.
{

  # --- Firefox ---
  "key_newNavigator" = "default"; # default: accel+N
  "key_newNavigatorTab" = "default"; # default: accel+T
  "focusURLBar" = "default"; # default: accel+L
  "focusURLBar2" = "default"; # default: alt+D
  "key_search" = "default"; # default: accel+K
  "key_search2" = "default"; # default: accel+J
  "key_openDownloads" = "default"; # default: accel+shift+Y
  "key_openAddons" = "default"; # default: accel+shift+A
  "openFileKb" = "default"; # default: (none / see about:keyboard)
  "key_savePage" = "default"; # default: accel+alt+shift+S
  "printKb" = "default"; # default: accel+P
  "key_close" = "default"; # default: accel+W
  "key_closeWindow" = "default"; # default: accel+shift+W
  "key_toggleMute" = "default"; # default: control+M
  "key_delete" = "default"; # default: VK_DELETE
  "goBackKb" = "default"; # default: alt+VK_LEFT
  "goForwardKb" = "default"; # default: alt+VK_RIGHT
  "goBackKb2" = "default"; # default: accel+[
  "goForwardKb2" = "default"; # default: accel+]
  "goHome" = "default"; # default: alt+VK_HOME
  "key_reload2" = "default"; # default: VK_F5
  "showAllHistoryKb" = "default"; # default: accel+shift+H
  "key_reload_skip_cache2" = "default"; # default: accel+VK_F5
  "key_enterFullScreen" = "default"; # default: VK_F11
  "key_exitFullScreen" = "default"; # default: VK_F11
  "key_toggleReaderMode" = "default"; # default: accel+alt+R
  "key_togglePictureInPicture" = "default"; # default: accel+shift+]
  "key_reload" = "default"; # default: accel+R
  "key_reload_skip_cache" = "default"; # default: accel+shift+R
  "key_aboutProcesses" = "default"; # default: shift+VK_ESCAPE
  "key_viewSource" = "default"; # default: accel+U
  "key_viewInfo" = "default"; # default: accel+I
  "key_find" = "default"; # default: accel+F
  "key_findAgain" = "default"; # default: accel+G
  "key_findPrevious" = "default"; # default: accel+shift+G
  "key_findAgain2" = "default"; # default: (none / see about:keyboard)
  "key_findPrevious2" = "default"; # default: (none / see about:keyboard)
  "addBookmarkAsKb" = "default"; # default: accel+D
  "bookmarkAllTabsKb" = "default"; # default: (none / see about:keyboard)
  "manBookmarkKb" = "default"; # default: accel+shift+O
  "viewBookmarksSidebarKb" = "default"; # default: accel+B
  "viewBookmarksToolbarKb" = "default"; # default: accel+shift+B
  "key_stop" = "default"; # default: (none / see about:keyboard)
  "viewGenaiChatSidebarKb" = "default"; # default: accel+alt+X
  "toggleSidebarKb" = "default"; # default: control+alt+Z
  "key_gotoHistory" = "default"; # default: accel+H
  "key_fullZoomReduce" = "default"; # default: accel+-
  "key_fullZoomEnlarge" = "default"; # default: accel++
  "key_fullZoomReset" = "default"; # default: accel+0
  "key_showAllTabs" = "default"; # default: control+shift+VK_TAB
  "key_switchTextDirection" = "default"; # default: accel+shift+X
  "key_privatebrowsing" = "default"; # default: accel+shift+P
  "key_screenshot" = "default"; # default: accel+shift+S
  "key_searchTabs" = "default"; # default: accel+shift+A
  "key_sanitize" = "default"; # default: accel+shift+VK_DELETE
  "key_quitApplication" = "disabled"; # default: accel+Q — no accidental Ctrl+Q
  "key_restoreLastClosedTabOrWindowOrSession" = "default"; # default: accel+shift+T
  "key_undoCloseWindow" = "default"; # default: (none / see about:keyboard)
  "key_selectTab1" = "default"; # default: alt+1
  "key_selectTab2" = "default"; # default: alt+2
  "key_selectTab3" = "default"; # default: alt+3
  "key_selectTab4" = "default"; # default: alt+4
  "key_selectTab5" = "default"; # default: alt+5
  "key_selectTab6" = "default"; # default: alt+6
  "key_selectTab7" = "default"; # default: alt+7
  "key_selectTab8" = "default"; # default: alt+8
  "key_selectLastTab" = "default"; # default: alt+9

  # --- Zen ---
  "zen-compact-mode-toggle" = { modifiers = "accel,shift"; key = "Z"; }; # default: accel+S — hide sidebar + top bar; NOTE steals text-field redo (Ctrl+Shift+Z)
  "zen-compact-mode-show-sidebar" = "default"; # default: accel+alt+S
  "zen-workspace-switch-1" = "disabled"; # default: alt+1 — Alt+N kept for key_selectTabN
  "zen-workspace-switch-2" = "disabled"; # default: alt+2
  "zen-workspace-switch-3" = "disabled"; # default: alt+3
  "zen-workspace-switch-4" = "disabled"; # default: alt+4
  "zen-workspace-switch-5" = "disabled"; # default: alt+5
  "zen-workspace-switch-6" = "disabled"; # default: alt+6
  "zen-workspace-switch-7" = "disabled"; # default: alt+7
  "zen-workspace-switch-8" = "disabled"; # default: alt+8
  "zen-workspace-switch-9" = "disabled"; # default: alt+9
  "zen-workspace-switch-10" = "disabled"; # default: alt+0
  "zen-workspace-forward" = "default"; # default: accel+alt+VK_RIGHT
  "zen-workspace-backward" = "default"; # default: accel+alt+VK_LEFT
  "zen-workspace-create" = "default"; # default: (none / see about:keyboard)
  "zen-close-all-unpinned-tabs" = "default"; # default: accel+shift+K
  "zen-split-view-grid" = "default"; # default: accel+alt+G
  "zen-split-view-vertical" = "default"; # default: accel+alt+V
  "zen-split-view-horizontal" = "default"; # default: accel+alt+H
  "zen-split-view-unsplit" = "default"; # default: accel+alt+U
  "zen-new-empty-split-view" = "default"; # default: accel+shift+*
  "zen-toggle-sidebar" = "default"; # default: (none / see about:keyboard)
  "zen-library-toggle" = "default"; # default: alt+shift+L
  "zen-glance-expand" = "default"; # default: accel+O
  "zen-toggle-pin-tab" = "default"; # default: accel+shift+D
  "zen-pinned-tab-reset-shortcut" = "default"; # default: (none / see about:keyboard)
  "zen-duplicate-tab" = "default"; # default: (none / see about:keyboard)
  "zen-new-unsynced-window" = "default"; # default: accel+shift+N
  "zen-copy-url" = { modifiers = "accel,alt,shift"; key = "C"; }; # default: accel+shift+C — moved off Ctrl+Shift+C
  "zen-copy-url-markdown" = "disabled"; # default: accel+alt+shift+C — its Ctrl+Alt+Shift+C now used by zen-copy-url
}
