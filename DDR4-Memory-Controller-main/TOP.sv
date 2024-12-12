module TOP;

//timeunit 1ns; timeprecision 1ns;

logic clock, full;
bit valid, done;
int time_in, operation_in;
logic [35:0] address_in;

readfile read(.clock(clock), .full(full), .clock_number(time_in), .command(operation_in), .address(address_in), .valid(valid), .done(done));
instruction_queue queue(.clock(clock),.time_in(time_in), .valid(valid), .operation_in(operation_in), .address_in(address_in), .done(done),. full(full));

initial begin
clock =1;
full = 0;
forever #5 clock = ~clock;
end

endmodule
/*The system comprises three modules: `readfile`, `memory_controller`, and `instruction_queue`.

1. **Readfile Module**:
   - Reads input data from a file, including timestamps, commands, and addresses.
   - Signals `valid` when new data is available and `done` when all data is read.
   
2. **Memory Controller Module**:
   - Manages memory operations, activating rows, precharging, and reading/writing to memory banks.
   - Receives commands from the `instruction_queue` and generates signals upon operation completion.
   
3. **Instruction Queue Module**:
   - Intermediary between `readfile` and `memory_controller`.
   - Stores incoming instructions in a queue and forwards them to the memory controller.
   - Manages the queue state (full/empty) and ensures correct order and timing of operations.

**Top-Level Working**:
- The `readfile` continuously reads data from a file and sends it to the `instruction_queue`.
- The `instruction_queue` stores and manages instruction flow, forwarding commands to the `memory_controller`.
- The `memory_controller` executes memory operations and signals completion.
- The top-level module coordinates communication between modules, enabling efficient memory operation execution 
based on file input.


Certainly! Let's walk through the top-level working of the system using the three modules: `readfile`, `memory_controller`, and `instruction_queue`.

1. **Readfile Module**:
   - The `readfile` module is responsible for reading input data from a file.
   - It continuously reads data from the file and provides it to the rest of the system.
   - The data typically includes a timestamp (`clock_number`), a command (`command`), and an address (`address`).
   - When there is valid data available, the `readfile` module sets the `valid` signal to indicate to other modules that new data is ready.
   - Once it finishes reading the file, it sets the `done` signal to indicate the end of data.

2. **Memory Controller Module**:
   - The `memory_controller` module manages the interaction with the memory system.
   - It receives commands from the `instruction_queue` module and performs memory operations accordingly.
   - It handles tasks such as activating rows, precharging, reading from, and writing to memory banks.
   - The `memory_controller` module may generate signals indicating the completion of memory operations.

3. **Instruction Queue Module**:
   - The `instruction_queue` module acts as an intermediary between the `readfile` module and the `memory_controller` module.
   - It receives data from the `readfile` module and stores it in a queue.
   - When the memory controller is ready to process a new memory operation, it retrieves the next command from the queue and forwards it to the memory controller.
   - It manages the flow of instructions to the memory controller, ensuring that operations are executed in the correct order and at the appropriate times.
   - It also manages the state of the queue, indicating when it is full or empty.

**Top-Level Working**:
- The top-level module instantiates the `readfile`, `memory_controller`, and `instruction_queue` modules.
- The `readfile` module continuously reads data from a file and provides it to the `instruction_queue` module.
- The `instruction_queue` module stores incoming instructions in a queue and forwards them to the `memory_controller` module as needed.
- The `memory_controller` module processes memory operations received from the `instruction_queue`, interacts with the memory system, and generates signals indicating
 the completion of operations.
- The top-level module ensures proper communication and coordination between the modules, allowing for the efficient execution of memory operations based on the input 
data read from the file.
*/