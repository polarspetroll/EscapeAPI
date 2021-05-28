# Escape API

an API for escaping html, shell and path queries

---

## Documentation

**parameters**
- **method** escaping method
- **data** string to be escaped

**available methods**

Method | Description |  Type | Prevention|
|---|---|---|---|
| html | HTML escape | string | XSS
| shell|  UNIX bourne shell escape| string | os command injection
| path | UNIX path escape | string | directory traversal

#### examples

```
curl "https://s.polarspetroll.repl.co?method=html&data=<>/>,test'"
```
output :
```json
{
  "ok":true,
  "data":"&lt;&gt;/&gt;,test&#39;"
}
```
---
```
curl "https://s.polarspetroll.repl.co/?method=shell&data=ls -la | cat /etc/passwd"
```

output:

```json
{
  "ok":true,
  "data":"ls\\ -la\\ \\|\\ cat\\ /etc/passwd"
}
```
---

```
curl "https://s.polarspetroll.repl.co/?method=path&data=../../../../../../../etc/passwd"
```

output:

```json
{
  "ok":true,
  "data":"./././././././etc/passwd"
}
```
