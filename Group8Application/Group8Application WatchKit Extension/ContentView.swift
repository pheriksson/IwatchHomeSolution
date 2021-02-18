//
//  ContentView.swift
//  test WatchKit Extension
//
//  Created by Robin Olofsson on 2021-01-28.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        //Detta är funktionen som applicerar viewn i klockan
        //Ifall du vill simulera klockan så väljer du watchkit
        //Telefon är bara namnet på projektet
        //Vstack är bara en struktur att hålla olika object (vertikalt) finns HStakc också
        
        VStack {
            Text("Vår health app")
                .padding()
            
            Text("Annat").padding()
        }
        
            
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
