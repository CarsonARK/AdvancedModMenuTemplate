//
//  Menu.h
//  BaseMenu
//
//  Created by Carson Mobile on 9/1/23.
//

#ifndef Menu_h
#define Menu_h
#include <vector>
#include <functional>
#include <string>
#include "KittyMemory/imgui.h"
#include "KittyMemory/imgui_internal.h"
#include "KittyMemory/imgui_impl_metal.h"

using namespace std;
class MenuIcon{
public:
    static MenuIcon& getInstance() {
        static MenuIcon instance; // The single instance
        return instance;
    }
    void DrawIcon();
    void SetIconURL(string imageURL);
    void SetLinkURL(string newURL);
    void SetIconSize(float x, float y);
private:
    ImVec2 IconSize;
    ImTextureID LogoTexture;
    string URL;
};


class TabBar {
public:
    TabBar();
    void DrawTabs();
    void AddTab(string TabName);
    int GetSelectedTab() const;
    int GetSelectedTab(string TabName) const;
    bool isTabSelected(string TabName) const;
    ImVec2 GetTabBarStartLocation();
    void BeginWindowChild();
private:
    vector<string> Tabs;
    int SelectedTab;
};

class MenuTab {
public:
    MenuTab() : isSelected(false) {}
    MenuTab(std::string TabName, std::function<void()> TabDrawFunction) {isSelected = false; Name = TabName; DrawFunction = TabDrawFunction;}
    void InitializeWithName(std::string TabName, std::function<void()> TabDrawFunction) {
        Name = TabName;
        DrawFunction = TabDrawFunction;
    }
    void TabDraw(ImVec2 ButtonSize);
    void Unselect();
    void Select();
    bool CheckSelected() const;
    void ExecuteDrawMenu() const;
    
private:
    std::string Name;
    std::function<void()> DrawFunction;
    bool isSelected;
};

class MainMenu{
public:
    MainMenu();
    void DrawMainMenu();
    void TabSelected(string TabName);
    void InitializeTab(MenuTab newTab);
    void HandleTabs(MenuTab& sender);
    static MainMenu& getInstance() {
        static MainMenu instance; // The single instance
        return instance;
    }
    ImVec2 GetMenuSize() const;
    ImVec2 GetMenuPos() const;
    ImVec2 GetLogoSize() const;
    float GetLogoToTabSpacing() const;
    float GetTabToPagesSpacing() const;
    ImVec2 CursorStart;
    string MenuName;
private:
    ImVec2 MenuSize;
    ImVec2 MenuPos;
    ImVec2 LogoSize;
    float LogoToTabSpacing;
    float TabsToPagesSpacing;
    std::vector<MenuTab> Tabs;
};

#endif /* Menu_h */
