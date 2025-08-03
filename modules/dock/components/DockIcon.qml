import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.services

Rectangle {
    id: dockIcon
    
    // Properties
    property string appId: ""
    property bool isPinned: false
    property bool isRunning: false
    property int workspace: 1
    property var dockWindow: null
    


    // Function to get icon path using the robust IconService
    function getIconPath(appId) {
        return IconService.getIconPath(appId)
    }
            

    // Signals
    signal appClicked()
    signal rightClicked()
    
    // Visual properties
    width: 48
    height: 48
    radius: 30
    color: isRunning ? "#004a9eff" : (isHovered ? "#333333" : "transparent")
    border.color: isRunning ? "#00555555" : (isHovered ? "#555555" : "transparent")
    border.width: isRunning ? 1 : (isHovered ? 1 : 0)
    
    // Hover effect
    property bool isHovered: false
    

    
    // Icon container
    Item {
        id: iconContainer
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        width: 32
        height: 32
        
        // Simple icon loading using the same approach as ApplicationMenu
        Image {
            id: appIcon
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: getIconPath(appId)
            
            // Fallback icon if the main icon fails
            onStatusChanged: {
                if (status === Image.Error) {
                            source = "image://icon/application-x-executable"
                }
            }
        }
        
        // Fallback text when icon is not visible
        Text {
            id: fallbackText
            anchors.centerIn: parent
            text: appId ? appId.split('.').pop() : "?"
            color: "#ffffff"
            font.pixelSize: 10
            font.bold: true
            visible: !appIcon.visible
        }
    }
    
    // Running indicator
    Rectangle {
        visible: isRunning
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: 4
        height: 4
        radius: 4
        color: "#00ccff"

        z: 5
    }
    
    
    // Context menu is handled directly in the mouse area
    
    // Mouse area for interactions
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onEntered: {
            dockIcon.isHovered = true
            dockIcon.scale = 1.1
        }
        
        onExited: {
            dockIcon.isHovered = false
            dockIcon.scale = 1.0
        }
        
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                dockIcon.appClicked()
            } else if (mouse.button === Qt.RightButton) {
                dockIcon.rightClicked()
                // Open context menu
                if (dockWindow && dockWindow.contextMenu) {
                            // If menu is already visible, close it
                            if (dockWindow.contextMenu.visible) {
                                dockWindow.contextMenu.hideMenu()
                                return
                            }
                            
                            // Get app info from HyprlandManager
                            let appInfo = null
                            let isPinned = false
                            
                            if (dockWindow.hyprlandManager) {
                                // Check if it's a running app
                                const runningApps = dockWindow.hyprlandManager.runningApps
                                const appWorkspaces = dockWindow.hyprlandManager.appWorkspaces
                                const appWindows = dockWindow.hyprlandManager.appWindows
                                
                                if (runningApps.includes(appId)) {
                                    appInfo = {
                                        class: appId,
                                        name: appId,
                                        toplevels: appWindows[appId] || []
                                    }
                                    console.log("Running app info:", appInfo)
                                    console.log("App windows:", appWindows[appId])
                                }
                            }
                            
                            // Check if it's a pinned app
                            if (dockWindow.pinnedAppsManager && dockWindow.pinnedAppsManager.pinnedApps) {
                                const pinnedApp = dockWindow.pinnedAppsManager.pinnedApps.find(app => app.id === appId || app.class === appId)
                                if (pinnedApp) {
                                    appInfo = pinnedApp
                                    isPinned = true
                                }
                            }
                            
                            // Set context and show menu
                            dockWindow.contextMenu.contextAppInfo = appInfo
                            dockWindow.contextMenu.contextIsPinned = isPinned
                            
                            // Position menu above the dock icon
                            const menuX = (width / 2) - (dockWindow.contextMenu.width / 2)
                            const menuY = -dockWindow.contextMenu.height + 15 // Above the icon
                            dockWindow.contextMenu.showAt(dockIcon, menuX, menuY)
                }
            }
        }
    }
    
    // Smooth scale animation
    Behavior on scale {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }
   
} 