% Generate the Transmitted Signal
N = 1000; % no. of samples
transmitted_signal = 2*randi([0,1],1,N)-1; % we do not want 0s
signal_power = 1; % Signal power (Ps)


% Calculate Noise Power
% SNR values in dB to simulate
snr_db = [-5, 0, 5, 10, 15];
error_rates = [];

%SIMULATION
for i = 1:length(snr_db)
    % Convert SNR from dB to linear scale
    snr_linear = 10^(snr_db(i)/10);

    % NOTE: snr = signal power / noise power
    noise_power = signal_power / snr_linear;
    scaling_factor = sqrt(noise_power);
    noise = randn(1, N) * scaling_factor;
    received_signal = transmitted_signal + noise;
    
    % Detection rule
    detected_signal = [];
    for j = 1:length(received_signal)
        if received_signal(j) > 0
            k = 1;
        else
            k = -1;
        end
        detected_signal = [detected_signal, k];
    end

    % Calculate error rate
    error_rate = sum(detected_signal ~= transmitted_signal) / N;
    error_rates = [error_rates, error_rate];
    fprintf('SNR (dB): %d, Error Rate: %.4f\n', snr_db(i), error_rate);
    
    % Plot transmitted signal
    figure;
    subplot(2,1,1);
    plot(transmitted_signal);
    title('Transmitted Signal');
    xlabel('Sample');
    ylabel('Amplitude');
    ylim([-2,2])

    % Plot received signal
    subplot(2,1,2);
    plot(received_signal);
    title('Received Signal');
    xlabel('Sample');
    ylabel('Amplitude');
    ylim([-2,2])
end

% Plot Error Rate vs. SNR
figure;
semilogy(snr_db, error_rates, 'o-');
title('Error Rate vs. SNR');
xlabel('SNR (dB)');