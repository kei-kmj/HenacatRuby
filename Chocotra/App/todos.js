const form = document.querySelector('#form');
const input = document.querySelector('#input');
const todos = document.querySelector('#todos');

// ページをロードしたときに、保存されているTODOアイテムを取得して表示する
function loadTodos() {
    fetch('/todos.json') // '/todos'はサーバのエンドポイントです
        .then(response => response.json())
        .then(data => {
            todos.innerHTML = ''; // clear the list before adding new items
            for (let item of data) {
                const li = document.createElement('li');
                li.textContent = item.task;
                todos.appendChild(li);
            }
        });
};

window.onload = loadTodos;

form.addEventListener('submit', function (event) {
    event.preventDefault();

    const text = input.value;
    input.value = '';

    const todo = {
        id: todos.children.length + 1, 
        task: text,
        completed: false,
    }

    // 新しいTODOアイテムをサーバに送信する
    fetch('/todos.json', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(todo), // 新しいTODOアイテムのテキスト
    })
    .then(response => {
        if(response.ok){
            loadTodos(); // reload todos list after successfully adding a new item
        }else{
            throw new Error('Failed to add new todo')
        }
    })
});
