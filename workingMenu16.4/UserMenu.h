//
//  UserMenu.h
//  BaseMenu
//
//  Created by Carson Mobile on 9/1/23.
//

#ifndef UserMenu_h
#define UserMenu_h

class UserMenu{
public:
    void Initialize();
    void DrawMenu();
    static UserMenu& getInstance() {
        static UserMenu instance; // The single instance
        return instance;
    }
};

#endif /* UserMenu_h */
