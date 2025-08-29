const N = 9 # Size of the matrix (N x N)

using LinearAlgebra
using Combinatorics


function decode_matrix(s::String)::Matrix{Int}
    """
    Decoder: convert the string to a matrix.
    Split the string by commas and convert to integers.
    """
    
    return reshape(parse.(Int, split(s, ',')), N, N)
end

function encode_matrix(m::Matrix{Int})::String
    """
    Encoder: convert the matrix to a flattened string.
    Convert the matrix to a flattened string and split with commas on each element.
    """

    return join(vec(m), ',')
end


function empty_starting_point()::String
    """
    empty_starting_point: return an empty graph as a string (define a inital starting point)

    try all one/zero matrix, or matrix with random [0, 1] values
    """

    mat = rand([-1, 0, 1], N, N)
    return encode_matrix(mat)
end


function reward_calc(obj::String)::REWARD_TYPE
    """
    For a square matrix A, (m, m), find the maximum absolute determinant of all submatrices, 
    which is any k x k submatrix for k = 2 to m.
    """

    A = decode_matrix(obj)
    # @show A[1:3, 1:3]  # Show a small part of the matrix for debugging
    max_det = 0.0

    for k in 2:N
        for rows in combinations(1:N, k)
            for cols in combinations(1:N, k)
                submatrix = A[rows, cols]
                det_val = abs(det(submatrix))
                # @show k, det_val  # Show the submatrix for debugging
                if det_val > max_det
                    max_det = det_val
                end
            end
        end
    end

    return max_det
end


function greedy_search_from_startpoint(db, obj::String)::Vector{String}
    """
    Main greedy search algorithm. 
    Perform local search to maximize the absolute determinant of submatrices of A.
    returns: Modified matrix with potentially higher maximum absolute determinant.

    random need to be set here
    """

    A = decode_matrix(obj)
    best_A = copy(A)
    best_delta = reward_calc(obj)

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
    println("Initial reward = ", best_delta)
    println("Best reward after search = ", reward_calc(encode_matrix(best_A)))
end
