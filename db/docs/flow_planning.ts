interface RuntimeFunctionDefintion {
    id: string // ref: runtime_id
}

interface RuntimeParameterDefinition {
    name: string // ref: runtime_name
}

interface FlowDefinition {

}

interface FlowNode {
    definiton: RuntimeFunctionDefintion
    next_node?: FlowNode
    parameters?: Parameter[] 
}

interface Parameter {
    defintion: RuntimeParameterDefinition
    value?: object
    sub_node?: FlowNode
}

interface Flow {
    starting_node: FlowNode
    defintion: FlowDefinition
}

//some examples for further explanation
const flow: Flow = {
    defintion: {
        
    },
    starting_node: {
        definiton: {
            id: "standard::math::add"
        },
        parameters: [
           {
            defintion: {
                name: "firstNumber"
            },
            value: {'firstNumber': 1}
           },
           {
            defintion: {
                name: "secondNumber"
            },
            sub_node: {
                definiton: {
                    id: "standard::date::get"
                }
            }
           }
        ],
        next_node: {
            definiton: {
                id: "standard::math::add"
            },
            parameters: [
               {
                defintion: {
                    name: "firstNumber"
                },
                value: {'firstNumber': '$result::1'}
               },
               {
                defintion: {
                    name: "secondNumber"
                },
                value: {'secondNumber': 5}
               }
            ],
        }
    }
}

const mathAdd = (value1, value2) => {
    return value1 + value2
}


const timeGet = () => {
    return 1
}

const flowTest = () => {

    const result1 = mathAdd(1, timeGet());
    const result2 = mathAdd(result1, 5)

}