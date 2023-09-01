//
//  Menu.m
//  BaseMenu
//
//  Created by Carson Mobile on 9/1/23.
//

#import <Foundation/Foundation.h>
#include "MenuLoad/Includes.h"
void MenuIcon::DrawIcon(){
    ImGui::PushStyleColor(ImGuiCol_Button, ImGuiCol_WindowBg);
    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImGuiCol_WindowBg);
    ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImGuiCol_WindowBg);
   /* float ButtonSize = IconSize.x < IconSize.y ? IconSize.x : IconSize.y;
    if(IconSize.x > IconSize.y){
        float DeltaWidth = IconSize.x - ButtonSize;
        float ButtonStartWidth = DeltaWidth/2;
        ImGui::SetCursorPos(ImVec2(ImGui::GetCursorPosX() + ButtonStartWidth, ImGui::GetCursorPosY()));
    }
    if(ImGui::ImageButton(LogoTexture, ImVec2(ButtonSize, ButtonSize))) */
    if(ImGui::ImageButton(LogoTexture, IconSize))
    {
        NSString* urlString = [NSString stringWithCString:URL.c_str() encoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
    ImGui::PopStyleColor(3);
}
void MenuIcon::SetIconURL(string imageURL){
    NSString *imageUrlString = [NSString stringWithCString:imageURL.c_str() encoding:NSUTF8StringEncoding];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:imageUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                id < MTLTexture > GlobalCTex = [[[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()] newTextureWithCGImage:image.CGImage options:nil error:nil];
                LogoTexture = (ImTextureID)CFBridgingRetain(GlobalCTex);
            }
        }
    }];
    [dataTask resume];
}
void MenuIcon::SetLinkURL(string newURL){
    URL = newURL;
}
void MenuIcon::SetIconSize(float x, float y){
    IconSize = ImVec2(x,y);
}



TabBar::TabBar(){
    SelectedTab = 0;
}
ImVec2 TabBar::GetTabBarStartLocation(){
    MainMenu& menu = MainMenu::getInstance();
    return ImVec2(menu.GetLogoSize().x + menu.GetTabToPagesSpacing() + menu.CursorStart.x + ImGui::GetWindowPos().x, menu.CursorStart.y + ImGui::GetWindowPos().y);
}

void TabBar::AddTab(string TabName){
    Tabs.push_back(TabName);
}
int TabBar::GetSelectedTab() const{
    return SelectedTab;
}
int TabBar::GetSelectedTab(string TabName) const{
    for(int i = 0; i<Tabs.size(); i++){
        if(Tabs[i] == TabName) return i;
    }
    return 0;
}
bool TabBar::isTabSelected(string TabName) const{
    for(int i = 0; i<Tabs.size(); i++){
        if(Tabs[i] == TabName) return i == SelectedTab;
    }
    return false;
}
void TabBar::DrawTabs(){
    MainMenu& menu = MainMenu::getInstance();
    float PageWidth = ImGui::GetWindowWidth() - (menu.GetLogoSize().x + menu.GetTabToPagesSpacing() + 20);
    ImGui::GetWindowDrawList()->AddRectFilled(GetTabBarStartLocation(), ImVec2(GetTabBarStartLocation().x + PageWidth, GetTabBarStartLocation().y + MainMenu::getInstance().GetLogoSize().y), ImGui::ColorConvertFloat4ToU32(ImGui::GetStyleColorVec4(ImGuiCol_Button)), 10);
    
    float ButtonWidth = PageWidth/Tabs.size();
    ImVec2 TabDrawPosition = ImVec2(menu.GetLogoSize().x + menu.GetTabToPagesSpacing() + menu.CursorStart.x, menu.CursorStart.y);
    for(int i = 0; i<Tabs.size(); ++i){
        if(SelectedTab == i){
            ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(1,0,0,0.7));
            ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(1,0,0,0.7));
            ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(1,0,0,0.7));
        } else {
            ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(1,0,0,0));
            ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(1,0,0,0));
            ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(1,0,0,0));
        }
        
        ImGui::SetCursorPos(TabDrawPosition);
        if(ImGui::Button(Tabs[i].c_str(), ImVec2(ButtonWidth, MainMenu::getInstance().GetLogoSize().y))){
            SelectedTab = i;
        }
        TabDrawPosition.x += ButtonWidth;
        
        ImGui::PopStyleColor(3);
    }
}
void TabBar::BeginWindowChild(){
    MainMenu& menu = MainMenu::getInstance();
    float PageWidth = ImGui::GetWindowWidth() - (menu.GetLogoSize().x + menu.GetTabToPagesSpacing() + 20);
    ImVec2 FunctionDrawStartLocation = ImVec2(10 + GetTabBarStartLocation().x - ImGui::GetWindowPos().x, 15 + MainMenu::getInstance().GetLogoSize().y + GetTabBarStartLocation().y - ImGui::GetWindowPos().y);
    ImVec2 FunctionBackgroundStartLocation = ImVec2(GetTabBarStartLocation().x , GetTabBarStartLocation().y + MainMenu::getInstance().GetLogoSize().y + 10);
    ImGui::GetWindowDrawList()->AddRectFilled(FunctionBackgroundStartLocation, ImVec2(FunctionBackgroundStartLocation.x + PageWidth , ImGui::GetWindowWidth() + ImGui::GetWindowPos().y - 40), ImGui::ColorConvertFloat4ToU32(ImGui::GetStyleColorVec4(ImGuiCol_Button)), 10);
    ImGui::SetCursorPos(FunctionDrawStartLocation);
    ImGui::BeginChild("CHILD", ImVec2(ImGui::GetWindowWidth() - (menu.GetTabToPagesSpacing() + menu.GetLogoSize().x), ImGui::GetWindowHeight() - (menu.GetLogoSize().y + menu.GetLogoToTabSpacing() + menu.CursorStart.y + 40)), false, ImGuiWindowFlags_None);
}


MainMenu::MainMenu(){
    float ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    float ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    float MenuHeight = ScreenHeight < 400 ? ScreenHeight : 400;
    MenuSize = ImVec2(400, MenuHeight);
    
    MenuPos = ImVec2(ScreenWidth/2 - 400/2, ScreenHeight/2 - MenuHeight/2);
    LogoSize = ImVec2(MenuSize.x / 4, MenuHeight / 13);
    LogoToTabSpacing = 10;
    TabsToPagesSpacing = 10;
    MenuName = "Testing Menu";
    MenuIcon::getInstance().SetIconURL("https://carsontoolcsvr.online/tedimage.png");
    MenuIcon::getInstance().SetLinkURL("https://github.com/CarsonARK/AdvancedModMenuTemplate");
    //https://github.com/CarsonARK/TheosModMenuTemplate
}
void MainMenu::InitializeTab(MenuTab newTab){
    Tabs.push_back(newTab);
}
ImVec2 MainMenu::GetMenuSize() const{
    return MenuSize;
}
ImVec2 MainMenu::GetMenuPos() const{
    return MenuPos;
}
ImVec2 MainMenu::GetLogoSize() const{
    return LogoSize;
}
float MainMenu::GetLogoToTabSpacing() const{
    return LogoToTabSpacing;
}
float MainMenu::GetTabToPagesSpacing() const{
    return TabsToPagesSpacing;
}

void MenuTab::Unselect(){
    isSelected = false;
}
void MenuTab::Select(){
    isSelected = true;
}
bool MenuTab::CheckSelected() const{
    return isSelected;
}
void MenuTab::TabDraw(ImVec2 ButtonSize){
    if(isSelected){
        ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(1,0,0,0.7));
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(1,0,0,0.7));
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(1,0,0,0.7));
        
        if(ImGui::Button(Name.c_str(), ButtonSize)){
            MainMenu::getInstance().HandleTabs(*this);
        }
        
        ImGui::PopStyleColor(3);
    }
    else {
        ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(1,0,0,0));
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(1,0,0,0));
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(1,0,0,0));
        
        if(ImGui::Button(Name.c_str(), ButtonSize)){
            MainMenu::getInstance().HandleTabs(*this);
        }
        ImGui::PopStyleColor(3);
    }
}
void MenuTab::ExecuteDrawMenu() const{
    DrawFunction();
}
void MainMenu::HandleTabs(MenuTab& sender){
    for(MenuTab& currentTab : Tabs){
        currentTab.Unselect();
    }
    sender.Select();
}
void MainMenu::DrawMainMenu(){
    
    static dispatch_once_t DpWindow;
    dispatch_once(&DpWindow, ^{
        ImGui::SetNextWindowPos(MenuPos);
        ImGui::SetNextWindowSize(MenuSize);
    });
    
    ImGuiWindowFlags MenuFlags = MoveMenu ? ImGuiWindowFlags_NoCollapse : ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove;
    ImGui::Begin(MenuName.c_str(), NULL, MenuFlags);


    ImVec2 StartingCursorPosition = ImGui::GetCursorPos();
    CursorStart = ImGui::GetCursorPos();
    MenuIcon::getInstance().SetIconSize(LogoSize.x, LogoSize.y);
    MenuIcon::getInstance().DrawIcon();

    MenuOrigin = ImGui::GetWindowPos();
    MenuSize = ImGui::GetWindowSize();
    
    ImVec2 TabStartPosition = ImVec2(StartingCursorPosition.x + 5, StartingCursorPosition.y + LogoSize.y + LogoToTabSpacing);
    
    float RemainingHeight = ImGui::GetWindowHeight() - TabStartPosition.y;
    float ButtonHeight = 40 < (RemainingHeight/Tabs.size()) + 5 ? 40 : (RemainingHeight/Tabs.size()) + 5;
    
    ImVec2 ButtonBackgroundRect = ImVec2(ImGui::GetWindowPos().x + StartingCursorPosition.x + 5, ImGui::GetWindowPos().y + StartingCursorPosition.y + LogoSize.y + LogoToTabSpacing);
    ImGui::GetWindowDrawList()->AddRectFilled(ButtonBackgroundRect, ImVec2(ButtonBackgroundRect.x + LogoSize.x - 5, ButtonBackgroundRect.y + ButtonHeight * Tabs.size()), ImGui::ColorConvertFloat4ToU32(ImGui::GetStyleColorVec4(ImGuiCol_Button)), 10);
    
    ImGui::SetCursorPos(TabStartPosition);
    ImGui::SetWindowFontScale(1.3);

    ImGui::PushStyleVar(ImGuiStyleVar_ButtonTextAlign, ImVec2(0, 0.5));

    for(MenuTab& CurrentTab : Tabs)
    {
        CurrentTab.TabDraw(ImVec2(LogoSize.x-5, ButtonHeight));
        TabStartPosition.y += ButtonHeight;
        ImGui::SetCursorPos(TabStartPosition);
    }

    ImGui::PopStyleVar();

    for(MenuTab& CurrentTab : Tabs){
        if(CurrentTab.CheckSelected()){
            CurrentTab.ExecuteDrawMenu();
            break;
        }
    }
    ImGui::SetWindowFontScale(1);
    ImGui::End();
}
