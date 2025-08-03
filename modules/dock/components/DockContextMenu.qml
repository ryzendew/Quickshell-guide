import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    id: contextMenu
    
    // Properties
    property string currentAppId: ""
    property var dockWindow: null
    property var anchorRect: Qt.rect(0, 0, 0, 0)
    
    // Menu structure using Quickshell menu components
    QsMenuHandle {
        id: menuHandle
        
        QsMenuEntry {
            text: "Move to Workspace"
            hasSubmenu: true
            
            QsMenuHandle {
                QsMenuEntry {
                    text: "Workspace 1"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 1)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 2"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 2)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 3"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 3)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 4"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 4)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 5"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 5)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 6"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 6)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 7"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 7)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 8"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 8)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 9"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 9)
                        menuHandle.close()
                    }
                }
                QsMenuEntry {
                    text: "Workspace 10"
                    onClicked: {
                        HyprlandManager.moveAppToWorkspace(currentAppId, 10)
                        menuHandle.close()
                    }
                }
            }
        }
        
        QsMenuEntry {
            text: "Toggle Floating"
            onClicked: {
                HyprlandManager.toggleAppFloating(currentAppId)
                menuHandle.close()
            }
        }
        
        QsMenuEntry {
            text: "Close"
            onClicked: {
                HyprlandManager.closeApp(currentAppId)
                menuHandle.close()
            }
        }
        
        QsMenuEntry {
            text: "Close All"
            onClicked: {
                HyprlandManager.closeAllAppWindows(currentAppId)
                menuHandle.close()
            }
        }
        
        QsMenuEntry {
            text: PinnedAppsManager.isPinned(currentAppId) ? "Unpin from Dock" : "Pin to Dock"
            onClicked: {
                if (PinnedAppsManager.isPinned(currentAppId)) {
                    PinnedAppsManager.unpinApp(currentAppId)
                } else {
                    PinnedAppsManager.pinApp(currentAppId)
                }
                menuHandle.close()
            }
        }
    }
    
    // Function to open menu for specific app
    function openForApp(appId, window, rect) {
        currentAppId = appId
        dockWindow = window
        anchorRect = rect
        menuHandle.open()
    }
    
    // Function to close menu
    function close() {
        menuHandle.close()
    }
} 