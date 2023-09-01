//
//  UserMenu.m
//  BaseMenu
//
//  Created by Carson Mobile on 9/1/23.
//

#import <Foundation/Foundation.h>
#include "MenuLoad/Includes.h"
static void BasicTab(){
    static TabBar MenuTwoTB;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        MenuTwoTB.AddTab("Basic");
    });
    MenuTwoTB.DrawTabs();
    MenuTwoTB.BeginWindowChild();
    if(MenuTwoTB.isTabSelected("Basic")){
        ImGui::Text("Basic");
        ImGui::Checkbox("Move Menu", &MoveMenu);
        ImGui::Checkbox("Streamer Mode", &StreamerMode);
    }
    ImGui::EndChild();
}
static void AimbotTab(){
    static TabBar MenuTwoTB;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        MenuTwoTB.AddTab("Legit");
        MenuTwoTB.AddTab("Blatant");
        MenuTwoTB.AddTab("Silent");
    });
    MenuTwoTB.DrawTabs();
    MenuTwoTB.BeginWindowChild();
    if(MenuTwoTB.isTabSelected("Legit")){
        ImGui::Text("Legit");
    }
    if(MenuTwoTB.isTabSelected("Blatant")){
        ImGui::Text("Blatant");
    }
    if(MenuTwoTB.isTabSelected("Silent")){
        ImGui::Text("Silent");
    }
    ImGui::EndChild();
}
static void ESPTab(){
    static TabBar MenuTwoTB;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        MenuTwoTB.AddTab("Players");
        MenuTwoTB.AddTab("Entities");
        MenuTwoTB.AddTab("CHAMS");
    });
    MenuTwoTB.DrawTabs();
    MenuTwoTB.BeginWindowChild();
    if(MenuTwoTB.isTabSelected("Players")){
        ImGui::Text("Players");
    }
    if(MenuTwoTB.isTabSelected("Entities")){
        ImGui::Text("Entities");
    }
    if(MenuTwoTB.isTabSelected("CHAMS")){
        ImGui::Text("CHAMS");
    }
    ImGui::EndChild();
    
}
static void CustomizeTab(){
    static TabBar MenuTwoTB;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        MenuTwoTB.AddTab("ESP Colors");
        MenuTwoTB.AddTab("Menu Colors");
    });
    MenuTwoTB.DrawTabs();
    MenuTwoTB.BeginWindowChild();
    if(MenuTwoTB.isTabSelected("ESP Colors")){
        ImGui::Text("ESP Colors");
    }
    if(MenuTwoTB.isTabSelected("Menu Colors")){
        ImGui::Text("Menu Colors");
    }
    ImGui::EndChild();
}
void UserMenu::Initialize(){
    ImGui::StyleColorsClassic();
    ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 8); //ScrollbarSize
    ImGui::PushStyleVar(ImGuiStyleVar_ScrollbarSize, 25);
    ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(0,0,0,1));
    ImGui::PushStyleVar(ImGuiStyleVar_ButtonTextAlign, ImVec2(0.5, 0.5));
    ImGui::PushStyleVar(ImGuiStyleVar_WindowTitleAlign, ImVec2(0.5, 0.5));

    MainMenu::getInstance() = MainMenu();
    MainMenu::getInstance().MenuName = "A Mod Menu";
    //ICON_FA_PLUS_CIRCLE "  Create New Profile"

    
    MainMenu::getInstance().InitializeTab(MenuTab(ICON_FA_WIND " Basic", BasicTab));
    MainMenu::getInstance().InitializeTab(MenuTab(ICON_FA_BULLSEYE " Aimbot", AimbotTab));
    MainMenu::getInstance().InitializeTab(MenuTab(ICON_FA_EYE " ESP", ESPTab));
    MainMenu::getInstance().InitializeTab(MenuTab(ICON_FA_STAR " Customize", CustomizeTab));
}
void UserMenu::DrawMenu(){
    MainMenu::getInstance().DrawMainMenu();
}
