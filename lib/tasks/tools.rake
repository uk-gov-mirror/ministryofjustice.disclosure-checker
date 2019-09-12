namespace :tools do
  # Simple and quick way of generating not very guessable, short and unique
  # reference codes to be used as the identifier of the MPV participants.
  # Removed letters and numbers that might cause confusion (like 1 and l).
  #
  # Run with: `bundle exec rake tools:generate_references[total]`
  #
  task :generate_references, [:total] do |_task, args|
    total = (args[:total] || 10).to_i

    alpha  = %w[a b c d e h k m n s u v w x z].freeze
    number = (2..9).to_a.freeze

    result = []
    count  = total

    loop do
      result += count.times.map do
        [alpha.sample, number.sample, alpha.sample, number.sample].join
      end

      result.uniq!

      # If we don't get the neccessary unique results in the first loop, we
      # set the counter to the remaining number, until we get them all.
      break if result.size == total

      count = (total - result.size)
    end

    puts result.join(',')
  end
end
