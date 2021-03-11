//
//  FibaroView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-02-22.
//

import SwiftUI


struct FibaroView: View {
    
    @State var bol = true
    var phoneCon : PhoneConnection?
    
    init(phoneCon: PhoneConnection){
        self.phoneCon = phoneCon
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    NavigationLink(
                        destination: lamp(phoneCon: self.phoneCon!),
                        label: {
                            Image(systemName: "lightbulb")
                        })
                    NavigationLink(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        label: {
                            Image(systemName: "desktopcomputer")
                        })
                    
                    
                }
            }
        }
    }
}
/*
struct FibaroView_Previews: PreviewProvider {
    static var previews: some View {
        FibaroView()
    }
}
*/
