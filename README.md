Analysis of Dot product using Floating point system and Posit Dot Product Unit


Abstract
This project explores the dot product calculation with a traditional floating-point system and the designed PDPU for better accuracy and precision. One of the applications of the dot product is the perceptron. The implementation would depend on the specific floating-point design and the available posit arithmetic modules. The perceptron takes input features, multiplying each by a learned weight, summing these products, adding a bias term, and then applying an activation function to determine the output. This implementation uses a step function for activation, making it suitable for binary classification tasks. A layered testbench in  SystemVerilog is an advanced approach used to model testbenches, especially for complex designs like processors, communication protocols, or neural networks. It separates different aspects of the testbench (stimulus generation, response checking, and reporting) into different layers, making it more modular and reusable. An open-source posit dot-product unit (PDPU) designed for deep learning applications. The PDPU aims to provide a resource-efficient, high-throughput hardware implementation for dot product operations using the posit number format. Key features include a fused and mixed-precision architecture and a fine-grained 6-stage pipeline, which improve computational efficiency and reduce hardware overhead. This dot product unit can be used in hardware accelerators for Machine learning algorithms (e.g., matrix multiplications in neural networks), DSP tasks such as filtering or convolution, Graphics or image processing tasks where vector operations are involved. Extending the design for pipelining or parallel processing, you can modify the design to handle larger vectors or integrate with a larger DSP system. To handle floating-point numbers, the design could be adjusted to work with floating-point units (FPUs) or fixed-point arithmetic, depending on the hardware requirements. The results of the dot product using the traditional floating-point system and using PDPU are compared and it's found that the posit system tends to give more accurate values for dot products and similar computations due to its dynamic precision and reduced rounding errors. However, it is important to consider the trade-offs in terms of hardware and software support when choosing between posits and traditional floating-point arithmetic.
Keywords: Dot product, Perceptron, Posit, Posit Dot Product Unit (PDPU), SystemVerilog, Layered testbench Environment

1. Introduction
A perceptron is the most basic unit of a neural network and a foundational concept in machine learning, particularly in the context of binary classification tasks. It was introduced by Frank Rosenblatt in 1958 and is used to model neurons in the brain, where each neuron receives multiple inputs, processes them, and then produces an output. The dot product plays a crucial role in perceptrons. The dot product in a perceptron is a fundamental mathematical operation that determines how the input features, when combined with their corresponding weights, influence the neuron's decision. It allows the perceptron to compute a linear combination of inputs and make a classification decision based on this weighted sum.
The testbench is structured to verify the functionality of the perceptron module by generating inputs, driving them to the DUT (Device Under Test), capturing the outputs, and comparing the actual results to the expected values. It also calculates the weighted sum and classifies the result as either 1 or 0.
Posit is an alternative to the IEEE754 floating-point format, offering a better trade-off between dynamic range and accuracy. While posit has shown promise in fields like weather forecasting, graph processing, and deep learning, efficient hardware implementation of posit-based dot-product operations remains a challenge. This project addresses this gap by proposing the PDPU, which aims to optimize latency, improve hardware efficiency, and ensure higher numerical precision compared to conventional discrete dot-product units (DPUs).
For a traditional floating-point system, a layered testbench in SystemVerilog is used to model testbenches, especially for complex designs like processors, communication protocols, or neural networks. It separates different aspects of the testbench (stimulus generation, response checking, and reporting) into different layers, making it more modular and reusable.
[1] Posit is a promising alternative to IEEE-754 for deep learning applications due to its better trade-off between dynamic range and accuracy. However, hardware implementation of posit arithmetic requires further exploration. An open-source posit dot-product unit, PDPU, is proposed for resource-efficient and high-throughput implementation. It features a fused architecture, fine-grained pipeline, and configurable generator. Experimental results show PDPU reduces area, latency, and power by up to 70%.
[2] The paper discusses the hardware implementation of the Posit Multiplier unit, an alternative to the IEEE-754 Floating point unit. The system provides more accurate results over the same word size and uses regime bits and exponent bits. An Adder-based Leading One Detector is proposed to reduce delay and area. Synthesized for 8-bit, 16-bit, and 32-bit, the results show a 17.55% reduction in delay and 28.35% increase in energy efficiency.
[3] The Posit number system is used in deep learning applications due to its non-uniform number distribution, enhancing training speed. However, hardware multipliers often have high power consumption due to the flexibility of posit numbers. This brief proposes a power-efficient posit multiplier architecture, dividing the multiplier into smaller ones controlled by the regime bit-width. This design reduces power consumption by an average of 16% with minimal area and timing overhead.
[4] The Posit number system is used in deep learning applications due to its non-uniform number distribution, enhancing training speed. However, hardware multipliers often have high power consumption due to the flexibility of posit numbers. This brief proposes a power-efficient posit multiplier architecture, dividing the multiplier into smaller ones controlled by the regime bit-width. This design reduces power consumption by an average of 16% with minimal area and timing overhead.
[16] The paper presents a floating-point eight-term fused dot product unit with mantissa-aware hardware design, addressing issues with conventional discrete constructions. The design uses a pre-shift and post-shift combined scheme for mantissa alignment, reducing latency and footprint. The design also analyses the impact of internal mantissa data-path width on calculation accuracy.

2. Methodology
2.1 Dot Product in Perceptron
The dot product in a perceptron is the sum of the products of corresponding input values (x) and their associated weights (w)  along with bias (b) is represented in Equation (1). 
The dot product between the input vector (x_(1,) x_(2,)….,x_(n,)) and weight vector (w_1,w_2,….,w_n) is
w⋅x=  w_1 x_1+w_2 x_2+w_3 x_3+⋯+w_n x_n                                                                      (1)

               


   <img width="481" height="333" alt="image" src="https://github.com/user-attachments/assets/73057799-7ab5-4030-95f8-9b378826eded" />





Fig1. Perceptron Dot Product


2.2 Configurable Layered Testbench


A Configurable Layered Testbench (CLTB) is a design framework used in the verification of digital hardware, especially in complex systems like system-on-chip (SoC) designs. Its goal is to use a methodical, reusable process to properly test hardware designs for accuracy and functionality. The layered Testbench architecture is shown in Fig 2 .


2.2.1 Generator


The generator plays a crucial role in creating inputs for the Design Under Test (DUT), ensuring comprehensive and effective testing. It can produce either completely random inputs or constrained random inputs, depending on the test's objectives. Random input generation is often used in stress testing, where data is generated without restrictions, helping to uncover edge cases and unexpected behaviours. In contrast, constrained random input generation applies specific limits or conditions, such as valid ranges or states, to produce meaningful and legally valid inputs that reflect real-world scenarios. The generated inputs can encompass various features such as signal values, control information, and, in the case of testing complex systems like neural networks, weights and bias values. This flexibility allows for a broad range of test cases, balancing randomness with relevance.

2.2.2  Driver

The driver serves the essential function of applying the generated inputs to the Design Under Test (DUT). It takes the stimulus produced by the generator and translates it into signals or transactions that the DUT can understand and respond to. This involves interfacing directly with the DUT’s input ports, driving changes in signals over time according to the test cases provided. By ensuring that the generated data is accurately applied to the DUT, the driver allows for proper evaluation of the DUT's response to different scenarios, making it a critical component in the testing process.


2.2.3 Monitor

The monitor plays a key role in observing the outputs of the Design Under Test (DUT) during simulation without affecting its behavior. It operates passively, meaning it does not interfere with or influence the DUT’s functioning. Instead, it captures and collects the output data generated by the DUT as a response to the applied stimuli. Once the outputs are recorded, the monitor forwards this information to the scoreboard, where the actual results can be compared against the expected outcomes. This process ensures accurate validation of the DUT’s performance by monitoring its behavior under various test conditions.




2.2.4 Scoreboard
The scoreboard serves as a critical validation component, ensuring that the outputs from the Design Under Test (DUT) align with the expected behavior. It performs a comparison between the actual outputs, captured by the monitor, and the expected results, which may be derived from a reference model, golden model, or a predefined mathematical specification. By carefully analyzing these outputs, the scoreboard determines whether the DUT has behaved as intended. If the actual output matches the expected result, the test is considered successful. However, any discrepancies between the two flag a failure, which could indicate a potential bug or flaw in the DUT's design. This process helps identify issues early in the testing phase.
2.2.5 Environment
The environment is the top-level component responsible for coordinating the overall testing process in a simulation. It manages the interaction between the generator, driver, monitor, and scoreboard, ensuring that each component functions in sync. The environment oversees the flow of the testbench by directing the generator to produce inputs, the driver to apply those inputs to the Design Under Test (DUT), the monitor to observe the outputs, and the scoreboard to validate the results. In addition to this coordination, the environment may handle tasks like resetting the DUT, configuring specific settings, or orchestrating multiple phases of the testbench. Its role is crucial in ensuring smooth and accurate simulation and validation.

                                                





<img width="505" height="486" alt="image" src="https://github.com/user-attachments/assets/c31b1803-3a4f-4979-8a5a-9aed515772ef" />



                                           
Fig2. Configurable Layered Testbench


2.3 Posit Dot Product Unit (PDPU )


PDPU focuses on optimizing dot-product operations by implementing efficient, fused, and mixed-precision techniques that significantly reduce area, latency, and power consumption compared to traditional architectures. By developing a fine-grained 6-stage pipeline, the design minimizes critical paths and enhances computational efficiency, ensuring faster and more reliable processing as represented in Fig 3 . Additionally, a configurable Posit Dot Product Unit (PDPU) generator is created, which supports various posit data types, dot product sizes, and alignment widths. This flexibility allows the system to adapt to different precision and performance requirements, making it suitable for a wide range of applications in efficient hardware computation.

<img width="940" height="241" alt="image" src="https://github.com/user-attachments/assets/5eb5463a-032a-4d8e-bd0f-21c0939dce4b" />

 
Fig3. Architecture of Proposed Posit Dot Product Unit (PDPU)


2.4 The PDPU features a 6-stage pipeline:

The stages featured by PDPU are as follows
1. Decode
2. Multiply
3. Align 
4. Accumulate
5. Normalize and Encode
In the decode stage it extracts valid components of inputs and calculates the sign and exponent of the product. In the multiply stage it performs mantissa multiplication and handles exponents. In the align stage it aligns product results and converts to two's complement. In the accumulate stage it compresses aligned mantissa and obtains accumulated results. In the normalize stage it performs mantissa normalization and exponent adjustments. In the encode stage it rounds and packs components into the final posit output.
2.5 Fused and Mixed-Precision Implementation
The PDPU employs fused arithmetic to achieve high computational and area efficiency by removing redundant logic. It also supports mixed-precision computation, allowing for flexible quantization strategies that can reduce computational complexity and memory requirements while maintaining model accuracy.
2.6 Configurable PDPU Generator
A key feature of the project is the configurable PDPU generator, which allows for flexible configurations in terms of posit formats, dot-product size, and alignment width as represented in Fig 4 . This adaptability makes the PDPU suitable for diverse computational needs in deep learning applications.





<img width="476" height="361" alt="image" src="https://github.com/user-attachments/assets/dfb9eb93-b8c5-4c83-b5a4-2524110f24d7" />




Fig4. Configurable PDPU Generator

3. Result and Analysis

   <img width="940" height="462" alt="image" src="https://github.com/user-attachments/assets/ba6c611a-b2f4-4556-8d63-bd2d03f86dfd" />

 
Fig5. Simulation results for dot product in perceptron

A perceptron is the simplest type of artificial neural network used for binary classification tasks, designed to distinguish between two classes. It functions by accepting many input values, each of which has a weight that indicates how important the input is. A weighted sum is created by multiplying these inputs by their corresponding weights and adding them all together as represented in Equation (2). An activation function, usually a step function, is applied to this sum to determine its output, which is set to 1 if the sum exceeds a threshold and 0 otherwise.
Using a technique known as gradient descent, the weights of the perceptron are modified during training in response to variations in the predicted and actual outputs. While perceptron are fundamental to machine learning, they can only solve linearly separable issues, which means they can only draw borders between classes in a straight line. Perceptrons, however, are fundamental building blocks of more intricate neural networks, such as multilayer perceptrons and deep learning models.
From the above waveform one can infer that the input features, weights, and bias begins at the successive clock edges which indicates the perceptron operation is satisfied. 
weighted_(sum_out )=∑_(i=0)^n▒〖(input_features[i] *weights[i]  )  + Bias〗 		          (2)

Additionally it is observed that weighted sum is then passed through an activation function (usually a step function or sign function) to produce the final output as represented in Equation (3). The step function outputs either 1 (if the  weighted_(sum_out ) is above a threshold) or 0 (if the weighted_(sum_out )is below the threshold).
         Result= {█(1                     if  weighted_(sum_out )≥threshold  @0                   otherwise                                              )┤		           (3)


<img width="714" height="368" alt="image" src="https://github.com/user-attachments/assets/4f0962bc-2ce8-41cd-bc22-985bedacf286" />

 
Fig 6. Scoreboard Result of Perceptron

The scoreboard layer plays a crucial role by maintaining a reference model of the expected results and comparing them against the DUT's output as shown in Fig 6 . This comparison helps in identifying discrepancies and ensuring that the DUT meets its functional requirements. The test layer focuses on defining specific scenarios and sequences to challenge the DUT, often using SystemVerilog's advanced features like constrained random generation for comprehensive testing. 


<img width="722" height="250" alt="image" src="https://github.com/user-attachments/assets/19aab53a-141f-49e8-ba8f-1e67c7667b9a" />





Fig 7. Coverage Report of Perceptron
To further enhance the verification process, functional coverage and assertions are employed as shown in Fig 7 and Fig 8.  Coverage metrics assess how much of the design has been exercised. By integrating these elements, the layered testbench ensures a robust verification process that can effectively validate the Perceptron design’s functionality and performance shown in Fig 5.
 
<img width="940" height="264" alt="image" src="https://github.com/user-attachments/assets/5c1b8c01-374a-426c-91ed-d4a70c6e9466" />

 
 Fig 8. Assertion Module of Perceptron


<img width="940" height="456" alt="image" src="https://github.com/user-attachments/assets/3e05d145-c0b9-4bb3-b734-f1ea3a929deb" />

 
                                          
                                                
Fig. 10 shows the simulation output of the Posit dot product unit by executing a typical testbench where two vectors a and b of 8 bits are given as inputs along with initial accumulator value and obtained the result of 16 bits. The obtained results are verified with the help of the Posit table .
4. Conclusion
This project presents an open-source, configurable posit dot-product unit (PDPU) and a perceptron designed for efficient dot product operations in deep learning applications. Layered testbench has been implemented and simulated. Assertions and coverages are carried out on Perceptron with 100% functional coverage. 
The PDPU's 6-stage pipeline, fused and mixed precision properties, and configurable generator make it a promising solution for improving the efficiency of posit-based arithmetic in hardware implementations for deep neural networks. A perceptron is the simplest type of artificial neural network used for binary classification tasks. It is a supervised learning algorithm that classifies input data into one of two classes based on a linear function. The Perceptron and the Posit Dot Product Unit (PDPU) are distinct in their purpose and capabilities, particularly regarding speed, performance, and efficiency. 
The perceptron, a simple neural network model used for classification, is typically slower because it relies on iterative processes like training and weight adjustments. Its performance is limited in handling complex tasks, especially with non-linearly separable data, and it uses floating-point arithmetic, which can introduce precision issues. The PDPU, on the other hand, is a hardware unit designed for fast, efficient dot product calculations using the posit number system. This system offers higher precision than traditional floating-point arithmetic with fewer bits, making computations faster and more accurate. PDPU's performance is optimized for tasks requiring high numerical accuracy, such as deep learning and scientific computing. In terms of efficiency, the perceptron, implemented in software, demands more computational resources, especially for large datasets or multilayer networks. The PDPU, by contrast, operates efficiently at the hardware level, using less power and fewer resources while maintaining high accuracy.



