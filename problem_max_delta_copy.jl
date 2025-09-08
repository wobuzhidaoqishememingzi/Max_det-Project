const N = 11 # Size of the matrix (N x N)

using LinearAlgebra
using Combinatorics

# global counters
const invalid_count = Threads.Atomic{Int}(0)  # Count of invalid matrices encountered
const total_count = Threads.Atomic{Int}(0)    # Total count of matrices processed

function decode_matrix(s::String)::Union{Matrix{Int}, Nothing}
    """
    Decoder: convert the string to a matrix.
    Split the string by commas and convert to integers.
    """

    s = replace(strip(s), r"[\s\r\n]+" => "") # Remove whitespace and newlines

    # valid format check
    # a valid matrix string should have N rows, each with N digits (0 or 1), separated by N-1 commas
    valid_rows = Regex("^([01]{$N})(,[01]{$N}){$(N-1)}\$")

    if !occursin(valid_rows, s)
        @warn "decode_matrix: invalid format for matrix string: '$s'"
        Threads.atomic_add!(invalid_count, 1)
        return nothing
    end

    rows = split(s, ',')

    # create the matrix
    mat = Matrix{Int}(undef, N, N)

    # check each element is either 0 or 1, and fill the matrix
    for i in 1:N
        r = collect(rows[i]) # split the current row string into characters, like '0', '1', ...
        for j in 1:N
            mat[i, j] = (r[j] == '1') ? 1 : 0 # convert char to int, if char is '1', then 1; else 0
        end
    end

    return mat

end


function invalid_report()
    """
    Report the number of invalid matrices encountered during decoding.
    """
    println("Total matrices processed: ", total_count[])
    println("Invalid matrices encountered: ", invalid_count[])
    ratio = total_count[] == 0 ? 0.0 : invalid_count[] / total_count[]
    println("Invalid ratio: ", ratio)
end


function encode_matrix(m::Matrix{Int})::String
    """
    Encoder: convert the matrix to a string.
    Each row is concatenated into a string of digits,
    and rows are separated by commas.
    """
    rows = [join(string.(m[i, :]), "") for i in 1:size(m, 1)]
    return join(rows, ",")
end

function empty_starting_point()::String
    """
    empty_starting_point: return an empty graph as a string (define a inital starting point)

    since we add randomness in the local search, here we can start with a fix all-zero matrix.
    """

    mat = zeros(Int, N, N)
    return encode_matrix(mat)
end


function reward_calc(obj::String)::REWARD_TYPE
    """
    For a square matrix A, (m, m), find the maximum absolute determinant of all submatrices, 
    which is any k x k submatrix for k = 2 to m.

    here we can only compute det(A), where A is the full N*N matrix, 
    the original matrix has the largest determinant (delta(A)).
    """

    A = decode_matrix(obj)
    if A === nothing
        return -1.0  # Invalid matrix string
    end
    return abs(det(A))  # Return the absolute value of the determinant of the full matrix A
end


function greedy_search_from_startpoint(db, obj::String)::Union{Nothing, Vector{String}}
    """
    Main greedy search algorithm. 
    Perform local search to maximize the absolute determinant of submatrices of A.
    returns: Modified matrix with potentially higher maximum absolute determinant.

    Add randomness here to explore different starting points.
    """

    A = decode_matrix(obj)
    Threads.atomic_add!(total_count, 1)
    if A === nothing
        @warn "greedy_search_from_startpoint: invalid matrix string: '$obj'"
        return String[]
    end

    # add randomness: flip some random elements in the matrix to be 1
    # using a threshold p to decide whether to flip an element or not,
    # loop over every element, if larger than p, flip it; if not, keep it as 0.
    p = 0.5  # Probability of flipping an element
    for i in 1:N, j in 1:N
        if rand() >= p
            A[i, j] = 1
        end
    end

    best_A = copy(A)
    best_delta = reward_calc(encode_matrix(best_A))

    for i in 1:N, j in 1:N
        for v in [0, 1]
            if A[i, j] == v
                continue  # Skip if no change
            end

            A_new = copy(best_A)
            A_new[i, j] = v

            new_delta = reward_calc(encode_matrix(A_new))
            if new_delta > best_delta
                best_delta = new_delta
                best_A = A_new
            end
        end
    end

    return [encode_matrix(best_A)]
end
