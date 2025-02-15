import SwiftUI

public struct AreaGraph: View {
    public var datas: [[CGFloat]]
    public var titulo: String
    public var legendas: [String]
    public var nomesEixoX: [String]
    public var colors: [Color]
    public var marginDireita: CGFloat
    public var marginEsquerda: CGFloat
    private var maiorValor: CGFloat = 0
    public var alturaGrafico: CGFloat
    let quantidadeY : Int
    
    public init(datas: [[CGFloat]] = [[100, 60.0, 117, 54, 56 ,13, 215, 100]], titulo: String = "Title", legendas: [String] = ["legenda"], nomeseixoX: [String] = ["0", "1", "2", "3", "4", "5", "6", "7"], colors: [Color] = [Color(red: 245 / 255, green: 69 / 255, blue: 79 / 255), Color(red: 146 / 255, green: 188 / 255, blue: 117 / 255), Color(red: 244 / 255, green: 150 / 255, blue: 63 / 255), Color(red: 89 / 255, green: 119 / 255, blue: 142 / 255), Color(red: 239 / 255, green: 114 / 255, blue: 65 / 255), Color(red: 247 / 255, green: 197 / 255, blue: 99 / 255), Color(red: 77 / 255, green: 168 / 255, blue: 141 / 255)], marginDireita: CGFloat = 25, marginEsquerda: CGFloat = 50, alturaGrafico: CGFloat = 200, quantidadeY: Int = 5) {
        self.datas = datas
        self.titulo = titulo
        self.legendas = legendas
        self.nomesEixoX = nomeseixoX
        self.colors = colors
        self.marginDireita = marginDireita
        self.marginEsquerda = marginEsquerda
        self.alturaGrafico = alturaGrafico
        self.quantidadeY = quantidadeY
        convertToPositive()
        self.maiorValor = acharMaiorValor()
    }
    
    public var body: some View {
        VStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                
                let widthSemMargem: CGFloat = width - marginEsquerda - marginDireita
                
                let centerY:CGFloat = geometry.size.height/2
                let centerX:CGFloat = width/2
                
                let quantidade: CGFloat = CGFloat(datas[0].count - 1)
                let espaco: CGFloat = widthSemMargem / quantidade
                
                let baseGrafico = centerY+self.alturaGrafico/2
                
                
                
                // Titulo do gráfico
                Text(titulo)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .position(x: centerX, y: baseGrafico-1.35*self.alturaGrafico)
                
                
                // Loop para cada array de dados
                ForEach(0..<datas.count, id: \.self) {
                    let data = datas[$0]

                    // Desenho da forma preenchida
                    Path { path in
                        path.move(to: CGPoint(x: marginEsquerda, y: baseGrafico))
                        
                        
                        for i in 0..<data.count {
                            path.addLine(to: CGPoint(x: espaco*CGFloat(i) + marginEsquerda, y: baseGrafico-convertToScale(valor: data[i])))
                            if i == data.count-1 {
                                path.addLine(to: CGPoint(x: widthSemMargem + marginEsquerda, y: baseGrafico))
                            }
                        }
                        
                    }.fill(colors[$0].opacity(0.3))
                    
                    //Desenho do contorno mais escuro da area
                    Path { path in
                        
                        path.move(to: CGPoint(x: marginEsquerda, y: baseGrafico-convertToScale(valor: data[0])))
                        
                        for i in 0..<data.count {
                            path.addLine(to: CGPoint(x: espaco*CGFloat(i) + marginEsquerda, y: baseGrafico-convertToScale(valor: data[i])))
                        }
                    }.stroke(colors[$0],lineWidth: 3)
                    
                    // Eixo X e Eixo Y
                    Path { path in
                        path.move(to: CGPoint(x: marginEsquerda, y: baseGrafico-alturaGrafico))
                        path.addLine(to: CGPoint(x: marginEsquerda, y: baseGrafico))
                        path.addLine(to: CGPoint(x: widthSemMargem + marginEsquerda, y: baseGrafico))
                    }.stroke(lineWidth: 4)
                    
                    //                    ForEach(0..<data.count, id: \.self) {
                    //                        Text(String(format: "%.2f", data[$0])).position(x: espaco*CGFloat($0) + margin, y: baseGrafico-convertToScale(valor: data[$0]))
                    //                    }
                    
                    // Desenho dos nomes do eixoX
                    ForEach(0..<nomesEixoX.count, id: \.self) {
                        Text(nomesEixoX[$0]).position(x: espaco*CGFloat($0) + marginEsquerda, y: baseGrafico + 25)
                            .font(.caption)
                        
                    }
                    
                    // Desenho dos valores no eixo Y
                    ForEach(0...quantidadeY, id: \.self) {
                        let espacamento: CGFloat = alturaGrafico/CGFloat(quantidadeY)
                        Text("\(Int(self.maiorValor)/quantidadeY*$0)").position(x: marginEsquerda - 25, y: baseGrafico - (espacamento * CGFloat($0)))
                            .font(.caption)
                    }
                    
                    // Desenho das legendas
                    HStack {
                        ForEach(0..<legendas.count, id: \.self) {
                            Rectangle()
                                .fill(colors[$0])
                                .frame(width: 10, height: 10)
                            Text(legendas[$0]).font(.subheadline)
                        }
                    }.position(x: centerX, y: centerY+self.alturaGrafico)
                    
                    
                }
            }.frame(height: self.alturaGrafico*2.25)
        }
    }
    
    
    // Funcao para converter numeros negativos em positivos
    mutating func convertToPositive() {
        for x in 0..<datas.count {
            for i in 0..<datas[x].count {
                if datas[x][i] < 0 {
                    datas[x][i] *= -1
                }
            }
        }
    }
    
    // Funcao para achar o maior valor entre os dados
    mutating func acharMaiorValor() -> CGFloat {
        var maior: CGFloat = 0
        for x in 0..<datas.count {
            for i in 0..<datas[x].count {
                if datas[x][i] > maior {
                    maior = datas[x][i]
                }
            }
        }
        return maior
    }
    
    // Funcao de regra de 3 para fazer o maior valor ser o 100% e o resto em relacao
    func convertToScale(valor: CGFloat) -> CGFloat {
        return valor * alturaGrafico / maiorValor
    }
    
}

struct AreaGraph_Previews: PreviewProvider {
    static var previews: some View {
        
        ScrollView {
            VStack{
                AreaGraph(datas: [[540,225,434, 432, 123, 543], [654, 132, 344, 500, 123, 250]], nomeseixoX: ["Agua e sal", "Lasanha", "Macarrao", "Doce", "Espaguete", "Pizza"], alturaGrafico: 100)
                AreaGraph()
                AreaGraph(datas: [[10.0, 60.0, 1, 12, 43, 65, 12, 87, 93, -100, 23, 54], [70.0, 54.0, 30.0, 43, 54, 100, 87, 69, 32, 65, 45, 67], [23,65,-87,13,42, 54.0, 20.0, 43, -300, 30, 65, 23]], titulo: "Monitoramento dos Focos Ativos em São Paulo", legendas: ["Queimada", "Árvores", "Água"], nomeseixoX: ["jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"], alturaGrafico: 150)
            }
        }
    }
}
