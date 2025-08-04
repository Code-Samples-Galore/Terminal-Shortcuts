#!/bin/bash
# Wordlist Formatting Functions
#
# Description: Functions for processing and formatting wordlists and text files.
# Includes sorting, deduplication, and other common wordlist operations.
#
# Functions:
#   wordlist   - Process wordlist files with sort and unique options
#
# Usage Examples:
#   $ wordlist file.txt           # Display wordlist as-is
#   $ wordlist -s file.txt        # Sort wordlist
#   $ wordlist -u file.txt        # Remove duplicates from wordlist
#   $ wordlist -s -u file.txt     # Sort and remove duplicates
#   $ wordlist -su file.txt       # Sort and remove duplicates (combined flags)
#   $ wordlist -min 5 file.txt    # Keep words with minimum 5 characters
#   $ wordlist -max 10 file.txt   # Keep words with maximum 10 characters
#   $ wordlist -min 3 -max 8 -su file.txt  # Filter by length, sort and unique
#   $ wordlist -minentropy 2.5 file.txt    # Keep words with minimum entropy 2.5
#   $ wordlist -maxentropy 4.0 file.txt    # Keep words with maximum entropy 4.0
#   $ wordlist -min 5 -minentropy 3.0 -su file.txt  # Complex filtering
#   $ wordlist -regex "^[a-z]+$" file.txt   # Keep only lowercase words
#   $ wordlist -notregex "[0-9]" file.txt   # Exclude words with numbers
#   $ wordlist -regex "pass" -min 4 -su file.txt  # Words containing "pass", min 4 chars, sorted unique
#   $ wordlist -i -regex "PASS" -min 4 -su file.txt  # Case-insensitive "pass", min 4 chars, sorted unique
#   $ wordlist -minnum 2 -maxnum 4 file.txt    # Words with 2-4 numbers
#   $ wordlist -minlower 3 -minupper 1 file.txt # Words with at least 3 lowercase and 1 uppercase
#   $ wordlist -minspecial 1 -max 12 -su file.txt # Words with at least 1 special char, max 12 total chars
#   $ wordlist -min 5 -su -o filtered.txt file.txt # Save filtered wordlist to file
#   $ wordlist -split 10MB -o parts.txt file.txt   # Split output into 10MB files
#   $ wordlist -split 1GB -o chunks.txt file.txt   # Split output into 1GB files
#   $ wordlist -splitpct "30 30 40" -o parts.txt file.txt  # Split into 30%, 30%, 40% files
#   $ wordlist -splitpct "50 50" -o halves.txt file.txt    # Split into two 50% files
#   $ wordlist -r -o random.txt file.txt        # Randomize word order
#   $ wordlist -min 8 -r -o filtered_random.txt file.txt  # Filter and randomize
#   $ wordlist -keepws file.txt                 # Keep only words with whitespace
#   $ wordlist -removews file.txt               # Remove words with whitespace
#   $ cat passwords.txt | wordlist -su -        # Read from stdin, sort and unique
#   $ echo -e "word1\nword2" | wordlist -min 5 - # Read from stdin with filtering

# Wordlist processing function
if ! should_exclude "wordlist" 2>/dev/null; then
  wordlist() {
    local sort_flag=false
    local unique_flag=false
    local min_length=""
    local max_length=""
    local min_entropy=""
    local max_entropy=""
    local min_numbers=""
    local max_numbers=""
    local min_lowercase=""
    local max_lowercase=""
    local min_uppercase=""
    local max_uppercase=""
    local min_special=""
    local max_special=""
    local regex_pattern=""
    local notregex_pattern=""
    local case_insensitive=false
    local randomize_flag=false
    local keep_whitespace=""
    local output_file=""
    local split_size=""
    local split_percentages=""
    local input_file=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
      case $1 in
        -s)
          sort_flag=true
          shift
          ;;
        -u)
          unique_flag=true
          shift
          ;;
        -su|-us)
          sort_flag=true
          unique_flag=true
          shift
          ;;
        -i)
          case_insensitive=true
          shift
          ;;
        -I)
          case_insensitive=false
          shift
          ;;
        -min)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -min requires a positive integer"
            return 1
          fi
          min_length="$2"
          shift 2
          ;;
        -max)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -max requires a positive integer"
            return 1
          fi
          max_length="$2"
          shift 2
          ;;
        -minentropy)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            echo "Error: -minentropy requires a positive number"
            return 1
          fi
          min_entropy="$2"
          shift 2
          ;;
        -maxentropy)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            echo "Error: -maxentropy requires a positive number"
            return 1
          fi
          max_entropy="$2"
          shift 2
          ;;
        -minnum)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -minnum requires a positive integer"
            return 1
          fi
          min_numbers="$2"
          shift 2
          ;;
        -maxnum)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -maxnum requires a positive integer"
            return 1
          fi
          max_numbers="$2"
          shift 2
          ;;
        -minlower)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -minlower requires a positive integer"
            return 1
          fi
          min_lowercase="$2"
          shift 2
          ;;
        -maxlower)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -maxlower requires a positive integer"
            return 1
          fi
          max_lowercase="$2"
          shift 2
          ;;
        -minupper)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -minupper requires a positive integer"
            return 1
          fi
          min_uppercase="$2"
          shift 2
          ;;
        -maxupper)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -maxupper requires a positive integer"
            return 1
          fi
          max_uppercase="$2"
          shift 2
          ;;
        -minspecial)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -minspecial requires a positive integer"
            return 1
          fi
          min_special="$2"
          shift 2
          ;;
        -maxspecial)
          if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: -maxspecial requires a positive integer"
            return 1
          fi
          max_special="$2"
          shift 2
          ;;
        -regex)
          if [[ -z "$2" ]]; then
            echo "Error: -regex requires a pattern"
            return 1
          fi
          regex_pattern="$2"
          shift 2
          ;;
        -notregex)
          if [[ -z "$2" ]]; then
            echo "Error: -notregex requires a pattern"
            return 1
          fi
          notregex_pattern="$2"
          shift 2
          ;;
        -o)
          if [[ -z "$2" ]]; then
            echo "Error: -o requires an output filename"
            return 1
          fi
          output_file="$2"
          shift 2
          ;;
        -split)
          if [[ -z "$2" ]]; then
            echo "Error: -split requires a size (e.g., 100MB, 1GB, 50000)"
            return 1
          fi
          # Validate split size format
          if [[ ! "$2" =~ ^[0-9]+([kmgtKMGT][bB]?)?$ ]]; then
            echo "Error: Invalid split size format. Use: number, numberK, numberM, numberG, etc."
            return 1
          fi
          split_size="$2"
          shift 2
          ;;
        -splitpct)
          if [[ -z "$2" ]]; then
            echo "Error: -splitpct requires percentages (e.g., \"30 30 40\", \"50 50\")"
            return 1
          fi
          # Validate percentage format and sum
          local pct_string="$2"
          local pct_array=($pct_string)
          local total_pct=0
          
          for pct in "${pct_array[@]}"; do
            if [[ ! "$pct" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
              echo "Error: Invalid percentage format '$pct'. Use numbers only."
              return 1
            fi
            total_pct=$(echo "$total_pct + $pct" | bc -l)
          done
          
          # Check if percentages sum to 100 (allow small floating point errors)
          if (( $(echo "$total_pct < 99.99 || $total_pct > 100.01" | bc -l) )); then
            echo "Error: Percentages must sum to 100. Current sum: $total_pct"
            return 1
          fi
          
          split_percentages="$2"
          shift 2
          ;;
        -r)
          randomize_flag=true
          shift
          ;;
        -keepws)
          keep_whitespace="keep"
          shift
          ;;
        -removews)
          keep_whitespace="remove"
          shift
          ;;
        -*)
          echo "Error: Unknown option '$1'"
          echo "Usage: wordlist [OPTIONS] <file|-> "
          echo "  -s                Sort the wordlist"
          echo "  -u                Remove duplicate entries"
          echo "  -su               Sort and remove duplicates"
          echo "  -r                Randomize word order"
          echo "  -i                Case-insensitive regex matching"
          echo "  -I                Case-sensitive regex matching (default)"
          echo "  -keepws           Keep only words containing whitespace"
          echo "  -removews         Remove words containing whitespace"
          echo "  -o FILE           Save output to file instead of stdout"
          echo "  -split SIZE       Split output into files of max SIZE (e.g., 100MB, 1GB)"
          echo "  -splitpct \"X Y Z\" Split output into files with X%, Y%, Z% of words"
          echo "  -min N            Keep words with minimum N characters"
          echo "  -max N            Keep words with maximum N characters"
          echo "  -minentropy E     Keep words with minimum entropy E"
          echo "  -maxentropy E     Keep words with maximum entropy E"
          echo "  -minnum N         Keep words with minimum N numbers"
          echo "  -maxnum N         Keep words with maximum N numbers"
          echo "  -minlower N       Keep words with minimum N lowercase letters"
          echo "  -maxlower N       Keep words with maximum N lowercase letters"
          echo "  -minupper N       Keep words with minimum N uppercase letters"
          echo "  -maxupper N       Keep words with maximum N uppercase letters"
          echo "  -minspecial N     Keep words with minimum N special characters"
          echo "  -maxspecial N     Keep words with maximum N special characters"
          echo "  -regex PATTERN    Keep words matching regex pattern"
          echo "  -notregex PATTERN Exclude words matching regex pattern"
          echo "Note: Use '-' as filename to read from stdin"
          return 1
          ;;

        *)
          if [[ -z "$input_file" ]]; then
            input_file="$1"
          else
            echo "Error: Multiple files specified. Only one file is supported."
            return 1
          fi
          shift
          ;;
      esac
    done
    
    # Check if file is provided
    if [[ -z "$input_file" ]]; then
      echo "Usage: wordlist [OPTIONS] <file|->"
      echo "  -s                Sort the wordlist"
      echo "  -u                Remove duplicate entries"
      echo "  -su               Sort and remove duplicates"
      echo "  -r                Randomize word order"
      echo "  -i                Case-insensitive regex matching"
      echo "  -I                Case-sensitive regex matching (default)"
      echo "  -keepws           Keep only words containing whitespace"
      echo "  -removews         Remove words containing whitespace"
      echo "  -o FILE           Save output to file instead of stdout"
      echo "  -split SIZE       Split output into files of max SIZE (e.g., 100MB, 1GB)"
      echo "  -splitpct \"X Y Z\" Split output into files with X%, Y%, Z% of words"
      echo "  -min N            Keep words with minimum N characters"
      echo "  -max N            Keep words with maximum N characters"
      echo "  -minentropy E     Keep words with minimum entropy E"
      echo "  -maxentropy E     Keep words with maximum entropy E"
      echo "  -minnum N         Keep words with minimum N numbers"
      echo "  -maxnum N         Keep words with maximum N numbers"
      echo "  -minlower N       Keep words with minimum N lowercase letters"
      echo "  -maxlower N       Keep words with maximum N lowercase letters"
      echo "  -minupper N       Keep words with minimum N uppercase letters"
      echo "  -maxupper N       Keep words with maximum N uppercase letters"
      echo "  -minspecial N     Keep words with minimum N special characters"
      echo "  -maxspecial N     Keep words with maximum N special characters"
      echo "  -regex PATTERN    Keep words matching regex pattern"
      echo "  -notregex PATTERN Exclude words matching regex pattern"
      echo "Note: Use '-' as filename to read from stdin"
      return 1
    fi
    
    # Check if file exists (skip check for stdin)
    if [[ "$input_file" != "-" && ! -f "$input_file" ]]; then
      echo "Error: File '$input_file' not found"
      return 1
    fi
    
    # Validate min/max relationship
    if [[ -n "$min_length" && -n "$max_length" && $min_length -gt $max_length ]]; then
      echo "Error: Minimum length ($min_length) cannot be greater than maximum length ($max_length)"
      return 1
    fi
    
    # Validate entropy relationship
    if [[ -n "$min_entropy" && -n "$max_entropy" ]] && (( $(echo "$min_entropy > $max_entropy" | bc -l) )); then
      echo "Error: Minimum entropy ($min_entropy) cannot be greater than maximum entropy ($max_entropy)"
      return 1
    fi
    
    # Validate character type min/max relationships
    if [[ -n "$min_numbers" && -n "$max_numbers" && $min_numbers -gt $max_numbers ]]; then
      echo "Error: Minimum numbers ($min_numbers) cannot be greater than maximum numbers ($max_numbers)"
      return 1
    fi
    
    if [[ -n "$min_lowercase" && -n "$max_lowercase" && $min_lowercase -gt $max_lowercase ]]; then
      echo "Error: Minimum lowercase ($min_lowercase) cannot be greater than maximum lowercase ($max_lowercase)"
      return 1
    fi
    
    if [[ -n "$min_uppercase" && -n "$max_uppercase" && $min_uppercase -gt $max_uppercase ]]; then
      echo "Error: Minimum uppercase ($min_uppercase) cannot be greater than maximum uppercase ($max_uppercase)"
      return 1
    fi
    
    if [[ -n "$min_special" && -n "$max_special" && $min_special -gt $max_special ]]; then
      echo "Error: Minimum special chars ($min_special) cannot be greater than maximum special chars ($max_special)"
      return 1
    fi
    
    # Create character counting and entropy calculation functions for awk
    local char_functions='
    function count_numbers(word) {
      count = 0;
      for (i = 1; i <= length(word); i++) {
        char = substr(word, i, 1);
        if (char ~ /[0-9]/) count++;
      }
      return count;
    }
    
    function count_lowercase(word) {
      count = 0;
      for (i = 1; i <= length(word); i++) {
        char = substr(word, i, 1);
        if (char ~ /[a-z]/) count++;
      }
      return count;
    }
    
    function count_uppercase(word) {
      count = 0;
      for (i = 1; i <= length(word); i++) {
        char = substr(word, i, 1);
        if (char ~ /[A-Z]/) count++;
      }
      return count;
    }
    
    function count_special(word) {
      count = 0;
      for (i = 1; i <= length(word); i++) {
        char = substr(word, i, 1);
        if (char !~ /[a-zA-Z0-9]/) count++;
      }
      return count;
    }
    
    function calculate_entropy(word) {
      delete freq;
      n = length(word);
      if (n == 0) return 0;
      
      # Count character frequencies
      for (i = 1; i <= n; i++) {
        char = substr(word, i, 1);
        freq[char]++;
      }
      
      # Calculate Shannon entropy
      entropy = 0;
      for (char in freq) {
        p = freq[char] / n;
        if (p > 0) {
          entropy -= p * log(p) / log(2);
        }
      }
      return entropy;
    }'
    
    # Build the filter conditions
    local filter_conditions=""
    
    # Length filtering
    if [[ -n "$min_length" && -n "$max_length" ]]; then
      filter_conditions="length(\$0) >= $min_length && length(\$0) <= $max_length"
    elif [[ -n "$min_length" ]]; then
      filter_conditions="length(\$0) >= $min_length"
    elif [[ -n "$max_length" ]]; then
      filter_conditions="length(\$0) <= $max_length"
    fi
    
    # Character type filtering
    local char_conditions=""
    
    # Numbers
    if [[ -n "$min_numbers" && -n "$max_numbers" ]]; then
      char_conditions="num_count >= $min_numbers && num_count <= $max_numbers"
    elif [[ -n "$min_numbers" ]]; then
      char_conditions="num_count >= $min_numbers"
    elif [[ -n "$max_numbers" ]]; then
      char_conditions="num_count <= $max_numbers"
    fi
    
    # Lowercase
    local lower_condition=""
    if [[ -n "$min_lowercase" && -n "$max_lowercase" ]]; then
      lower_condition="lower_count >= $min_lowercase && lower_count <= $max_lowercase"
    elif [[ -n "$min_lowercase" ]]; then
      lower_condition="lower_count >= $min_lowercase"
    elif [[ -n "$max_lowercase" ]]; then
      lower_condition="lower_count <= $max_lowercase"
    fi
    
    if [[ -n "$char_conditions" && -n "$lower_condition" ]]; then
      char_conditions="$char_conditions && $lower_condition"
    elif [[ -n "$lower_condition" ]]; then
      char_conditions="$lower_condition"
    fi
    
    # Uppercase
    local upper_condition=""
    if [[ -n "$min_uppercase" && -n "$max_uppercase" ]]; then
      upper_condition="upper_count >= $min_uppercase && upper_count <= $max_uppercase"
    elif [[ -n "$min_uppercase" ]]; then
      upper_condition="upper_count >= $min_uppercase"
    elif [[ -n "$max_uppercase" ]]; then
      upper_condition="upper_count <= $max_uppercase"
    fi
    
    if [[ -n "$char_conditions" && -n "$upper_condition" ]]; then
      char_conditions="$char_conditions && $upper_condition"
    elif [[ -n "$upper_condition" ]]; then
      char_conditions="$upper_condition"
    fi
    
    # Special characters
    local special_condition=""
    if [[ -n "$min_special" && -n "$max_special" ]]; then
      special_condition="special_count >= $min_special && special_count <= $max_special"
    elif [[ -n "$min_special" ]]; then
      special_condition="special_count >= $min_special"
    elif [[ -n "$max_special" ]]; then
      special_condition="special_count <= $max_special"
    fi
    
    if [[ -n "$char_conditions" && -n "$special_condition" ]]; then
      char_conditions="$char_conditions && $special_condition"
    elif [[ -n "$special_condition" ]]; then
      char_conditions="$special_condition"
    fi
    
    # Entropy filtering
    if [[ -n "$min_entropy" || -n "$max_entropy" ]]; then
      local entropy_condition=""
      if [[ -n "$min_entropy" && -n "$max_entropy" ]]; then
        entropy_condition="entropy >= $min_entropy && entropy <= $max_entropy"
      elif [[ -n "$min_entropy" ]]; then
        entropy_condition="entropy >= $min_entropy"
      elif [[ -n "$max_entropy" ]]; then
        entropy_condition="entropy <= $max_entropy"
      fi
      
      if [[ -n "$filter_conditions" ]]; then
        filter_conditions="$filter_conditions && $entropy_condition"
      else
        filter_conditions="$entropy_condition"
      fi
    fi
    
    # Combine all conditions
    if [[ -n "$filter_conditions" && -n "$char_conditions" ]]; then
      filter_conditions="$filter_conditions && $char_conditions"
    elif [[ -n "$char_conditions" ]]; then
      filter_conditions="$char_conditions"
    fi
    
    # Process the file with streaming approach
    local processing_pipeline=""
    
    # Check if we need character type filtering or entropy
    local needs_char_analysis=false
    if [[ -n "$min_numbers" || -n "$max_numbers" || -n "$min_lowercase" || -n "$max_lowercase" || -n "$min_uppercase" || -n "$max_uppercase" || -n "$min_special" || -n "$max_special" || -n "$min_entropy" || -n "$max_entropy" ]]; then
      needs_char_analysis=true
    fi
    
    # Start with basic filtering using awk for efficient line-by-line processing
    if [[ -n "$filter_conditions" || "$needs_char_analysis" == true ]]; then
      local awk_script="$char_functions"
      if [[ "$needs_char_analysis" == true ]]; then
        awk_script="$awk_script { 
          num_count = count_numbers(\$0);
          lower_count = count_lowercase(\$0);
          upper_count = count_uppercase(\$0);
          special_count = count_special(\$0);"
        
        if [[ -n "$min_entropy" || -n "$max_entropy" ]]; then
          awk_script="$awk_script entropy = calculate_entropy(\$0);"
        fi
        
        awk_script="$awk_script if ($filter_conditions) print \$0; }"
      else
        awk_script="$awk_script { if ($filter_conditions) print \$0; }"
      fi
      
      if [[ "$input_file" == "-" ]]; then
        processing_pipeline="awk '$awk_script'"
      else
        processing_pipeline="awk '$awk_script' '$input_file'"
      fi
    else
      if [[ "$input_file" == "-" ]]; then
        processing_pipeline="cat"
      else
        processing_pipeline="cat '$input_file'"
      fi
    fi
    
    # Add regex filtering
    local grep_flags=""
    if [[ "$case_insensitive" == true ]]; then
      grep_flags="-i"
    fi
    
    if [[ -n "$regex_pattern" ]]; then
      processing_pipeline="$processing_pipeline | grep $grep_flags -E '$regex_pattern'"
    fi
    
    if [[ -n "$notregex_pattern" ]]; then
      processing_pipeline="$processing_pipeline | grep $grep_flags -v -E '$notregex_pattern'"
    fi
    
    # Add whitespace filtering
    if [[ "$keep_whitespace" == "keep" ]]; then
      processing_pipeline="$processing_pipeline | grep -E '[[:space:]]'"
    elif [[ "$keep_whitespace" == "remove" ]]; then
      processing_pipeline="$processing_pipeline | grep -v -E '[[:space:]]'"
    fi
    
    # Handle sort, unique, and randomize operations efficiently
    if [[ "$sort_flag" == true && "$unique_flag" == true ]]; then
      # Sort and unique in one pass
      processing_pipeline="$processing_pipeline | sort -u"
    elif [[ "$sort_flag" == true ]]; then
      # Sort only
      processing_pipeline="$processing_pipeline | sort"
    elif [[ "$unique_flag" == true ]]; then
      # Unique only (preserves original order) - use awk for memory efficiency
      processing_pipeline="$processing_pipeline | awk '!seen[\$0]++'"
    fi
    
    # Add randomization - use shuf for efficient random ordering
    if [[ "$randomize_flag" == true ]]; then
      # Check if shuf is available
      if command -v shuf >/dev/null 2>&1; then
        processing_pipeline="$processing_pipeline | shuf"
      else
        # Fallback to awk-based randomization for systems without shuf
        processing_pipeline="$processing_pipeline | awk 'BEGIN{srand()} {print rand() \"\t\" \$0}' | sort -n | cut -f2-"
      fi
    fi
    
    # Execute the pipeline
    if [[ -n "$output_file" ]]; then
      # Check for output file conflicts
      if [[ -n "$output_file" ]]; then
        # Check if output file is the same as input file
        if [[ "$output_file" -ef "$input_file" ]]; then
          echo "Error: Output file cannot be the same as input file"
          return 1
        fi
        
        # For split modes, check if any existing split files would conflict
        if [[ -n "$split_size" || -n "$split_percentages" ]]; then
          local base_name="${output_file%.*}"
          local extension="${output_file##*.}"
          if [[ "$base_name" == "$extension" ]]; then
            extension=""
          else
            extension=".$extension"
          fi
          
          # Check for existing split files
          local existing_splits=(${base_name}_part_*${extension})
          if [[ ${#existing_splits[@]} -gt 0 && -f "${existing_splits[0]}" ]]; then
            echo -n "Split files '${base_name}_part_*${extension}' exist. Overwrite? (y/N): "
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
              echo "Operation cancelled"
              return 1
            fi
            # Remove existing split files
            rm -f ${base_name}_part_*${extension}
          fi
        else
          # Check if output file exists and prompt for confirmation
          if [[ -f "$output_file" ]]; then
            echo -n "Output file '$output_file' exists. Overwrite? (y/N): "
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
              echo "Operation cancelled"
              return 1
            fi
          fi
        fi
        
        # Check if output directory is writable
        local output_dir
        output_dir=$(dirname "$output_file")
        if [[ ! -w "$output_dir" ]]; then
          echo "Error: Cannot write to directory '$output_dir'"
          return 1
        fi
      fi
      
      if [[ -n "$split_percentages" ]]; then
        # Split the output into percentage-based files
        local base_name="${output_file%.*}"
        local extension="${output_file##*.}"
        if [[ "$base_name" == "$extension" ]]; then
          extension=""
        else
          extension=".$extension"
        fi
        
        # Create temporary file to store all processed output
        local temp_file=$(mktemp)
        eval "$processing_pipeline" > "$temp_file"
        local exit_code=${PIPESTATUS[0]}
        
        if [[ $exit_code -eq 0 ]]; then
          local total_words=$(wc -l < "$temp_file")
          local pct_array=($split_percentages)
          local current_line=1
          local file_index=1
          
          echo "Splitting $total_words words into ${#pct_array[@]} percentage-based files:"
          
          for pct in "${pct_array[@]}"; do
            local words_in_file=$(echo "scale=0; $total_words * $pct / 100" | bc -l)
            words_in_file=${words_in_file%.*}  # Remove decimal part
            
            # For the last file, take all remaining words to handle rounding
            if [[ $file_index -eq ${#pct_array[@]} ]]; then
              words_in_file=$((total_words - current_line + 1))
            fi
            
            local output_part="${base_name}_part_$(printf "%02d" $file_index)${extension}"
            
            if [[ $words_in_file -gt 0 ]]; then
              sed -n "${current_line},$((current_line + words_in_file - 1))p" "$temp_file" > "$output_part"
              local actual_words=$(wc -l < "$output_part")
              local actual_pct=$(echo "scale=1; $actual_words * 100 / $total_words" | bc -l)
              local size=$(ls -lh "$output_part" | awk '{print $5}')
              echo "  $output_part: $actual_words words (${actual_pct}%, $size)"
              current_line=$((current_line + words_in_file))
            else
              # Create empty file for 0% splits
              touch "$output_part"
              echo "  $output_part: 0 words (0%, 0B)"
            fi
            
            file_index=$((file_index + 1))
          done
          
          echo "Total: $total_words words split into ${#pct_array[@]} files"
        else
          echo "Error: Failed to process wordlist"
          rm -f "$temp_file"
          return $exit_code
        fi
        
        # Clean up temporary file
        rm -f "$temp_file"
        
      elif [[ -n "$split_size" ]]; then
        # Split the output into multiple files
        local base_name="${output_file%.*}"
        local extension="${output_file##*.}"
        if [[ "$base_name" == "$extension" ]]; then
          extension=""
        else
          extension=".$extension"
        fi
        
        # Use split command with size-based splitting
        eval "$processing_pipeline" | split -d -b "$split_size" - "${base_name}_part_"
        
        # Add extension to split files if needed
        if [[ -n "$extension" ]]; then
          for file in ${base_name}_part_*; do
            if [[ -f "$file" && ! "$file" =~ $extension$ ]]; then
              mv "$file" "${file}${extension}"
            fi
          done
        fi
        
        local exit_code=${PIPESTATUS[0]}
        if [[ $exit_code -eq 0 ]]; then
          local split_files=(${base_name}_part_*${extension})
          local total_words=0
          local file_count=${#split_files[@]}
          
          echo "Processed wordlist split into $file_count files:"
          for file in "${split_files[@]}"; do
            if [[ -f "$file" ]]; then
              local words=$(wc -l < "$file" 2>/dev/null || echo "0")
              local size=$(ls -lh "$file" | awk '{print $5}')
              echo "  $file: $words words ($size)"
              total_words=$((total_words + words))
            fi
          done
          echo "Total: $total_words words"
        else
          echo "Error: Failed to process wordlist"
          return $exit_code
        fi
      else
        # Single output file
        eval "$processing_pipeline" > "$output_file"
        local exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
          local word_count
          word_count=$(wc -l < "$output_file")
          echo "Processed wordlist saved to '$output_file' ($word_count words)"
        else
          echo "Error: Failed to process wordlist"
          return $exit_code
        fi
      fi
    else
      eval "$processing_pipeline"
    fi
  }
fi
