% === Проверка наличия plsDS ===
if ~exist('plsDS', 'var')
    error('В workspace нет переменной plsDS');
end

% Создаём папку для таблиц
outFolder = 'plsDS_soc455055_fr2_2RC_R0free_pls_tables';
if ~exist(outFolder, 'dir')
    mkdir(outFolder);
end

N = height(plsDS);

% Поля, которые есть в plsDS
fields = plsDS.Properties.VariableNames;

% Поле таблицы (3813×5)
tableField = 'data';

% Поле структуры (7×1)
structField = 'fitres';

% Поля, которые записываем в основной CSV
mainFields = setdiff(fields, {tableField, structField});

% Заготовка структуры
main = struct();
for f = mainFields
    main.(f{1}) = cell(N,1);
end
main.table_file = cell(N,1);

fprintf("Конвертация %d записей...\n", N);

% === Основной цикл ===
for i = 1:N
    
    % --- 1. Обычные поля ---
    for f = mainFields
        main.(f{1}){i} = plsDS.(f{1})(i);
    end
    
    % --- 2. Таблица 3813×5 ---
    tbl = plsDS.data{i};        % 3813×5 table
    fname = sprintf("%s.csv", plsDS.name{i});
    writetable(tbl, fullfile(outFolder, fname));

    main.table_file{i} = fname;

    fprintf(" [%d/%d] %s → %s\n", i, N, plsDS.name{i}, fname);
end

% === 3. Создание основного CSV ===
mainTable = struct2table(main);
writetable(mainTable, 'plsDS_soc455055_fr2_2RC_R0free_main.csv');

fprintf("\nГотово!\n");
fprintf(" - создан plsDS_main.csv\n");
fprintf(" - %d таблиц в папке %s\n", N, outFolder);
