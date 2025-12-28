# PowerShell script to rename all engineering diagram files

# CSE Renames
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\1.webp" "avl_tree.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\2.webp" "b_tree.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\3.webp" "graph_representations.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\4.webp" "sorting_algorithms.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\5.webp" "stack_queue.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\6.webp" "heap_structure.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\7.webp" "trie_structure.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\8.webp" "red_black_tree.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\9.webp" "dijkstra_algorithm.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\cse\10.webp" "memory_management.webp" -ErrorAction SilentlyContinue

# ECE Renames
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\1.webp" "transistor_config.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\2.webp" "flip_flops.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\3.webp" "counters.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\4.webp" "mux_demux.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\5.webp" "encoder_decoder.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\6.webp" "filter_circuits.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\7.webp" "oscillator_circuits.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\8.webp" "modulation_techniques.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\9.webp" "number_systems.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\ece\10.webp" "shift_registers.webp" -ErrorAction SilentlyContinue

Write-Host "All files renamed successfully!" -ForegroundColor Green
