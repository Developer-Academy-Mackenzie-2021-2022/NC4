//
//  ContentView.swift
//  EixosTeste
//
//  Created by Rebecca Mello on 29/10/21.
//

import SwiftUI

struct CandleStickAxis<Child: View>: View {
    var xTitle: String
    var yTitle: String
//    var xLabels: [String]
    var yLabels: [String]
    
    @ViewBuilder var child: () -> Child
    @ViewBuilder func axis(_ size: CGSize) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: size.height)) // ponto final
            path.addLine(to: CGPoint(x: 0, y: 0)) // ponto inicial
        }.stroke(Color.black, lineWidth: 2)
        
        Path { path in
            path.move(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }.stroke(Color.black, lineWidth: 2)
    }
    
    var body: some View {
        
        HStack {
//            let multiplierX: CGFloat = (1/CGFloat(xLabels.count))
            let multiplierY: CGFloat = (1/CGFloat(yLabels.count))
            
            //MARK: Labels do eixo Y
            HStack(alignment: .top) {
                VStack {
                    GeometryReader { proxy in
                        ForEach(0..<(yLabels.count)) { i in
                            let label: String = yLabels[i]
                            let yPosition = (proxy.size.height*multiplierY) * CGFloat(i)
                            Text("\(label)")
                                .font(.system(size: 12))
                                .offset(x: 12, y: yPosition-7)

                        }
                    }.frame(width: 50)
                }.padding()
            }
            .frame(width: 40)
            
            
            //MARK: Gráfico
            VStack(alignment: .leading) {
//                Text("\(yTitle)")
                GeometryReader { proxy in
                    ZStack {
                        // Eixos Y
                        ForEach(0..<(yLabels.count)) { i in
                            Path { path in
                                let yPosition = (proxy.size.height*multiplierY) * CGFloat(i)
                                path.move(to: CGPoint(x: proxy.size.width, y: yPosition))
                                path.addLine(to: CGPoint(x: 0 , y: yPosition))
                            }.stroke(Color.black.opacity(0.2))
                        }
                        
                        axis(proxy.size)
                        child()
                        
                        // Eixos X
//                        ForEach(1..<(xLabels.count+1)) { i in
//                            Path { path in
//                                let xPosition = (proxy.size.width*multiplierX) * CGFloat(i)
//                                path.move(to: CGPoint(x: xPosition, y: 0))
//                                path.addLine(to: CGPoint(x:xPosition , y: proxy.size.height))
//                            }
//                        }
                        
                        
                    }
                }
                
                //MARK: Labels do eixo X
//                HStack {
//                    GeometryReader { proxy in
//                        ForEach(1..<(xLabels.count+1)) { i in
//                            let label: String = xLabels[i-1]
//                            let xPosition = (proxy.size.width*multiplierX) * CGFloat(i)
//                            Text("\(label)")
//                                .font(.system(size: 12))
//                                .position(x: xPosition, y: proxy.size.height)
//                        }
//                    }.foregroundColor(.red)
//                }.frame(height: 30)
            }.padding()
            
            
//            Text("\(xTitle)")
//                .padding(.trailing, 20)
        }.padding(.trailing, 20)
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        CandleStickAxis(xTitle: "EixoX", yTitle: "EixoY", yLabels: ["6000", "5000", "4000", "3000", "2000", "1000"]) {
            CandlestickChart().padding()
        }
        .previewLayout(.fixed(width: 400, height: 400))
    }
}
